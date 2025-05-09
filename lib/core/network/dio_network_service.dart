import 'dart:async';
import 'dart:io';

import 'package:codersgym/core/network/network_service.dart';
import 'package:codersgym/features/common/widgets/app_error_notifier.dart';
import 'package:dio/dio.dart';
import 'package:exponential_back_off/exponential_back_off.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class DioNetworkService extends NetworkService {
  DioNetworkService({
    required this.configuration,
    required this.interceptors,
    required this.appErrorNotifier,
    Dio? dioClient,
  }) : _dio = dioClient;
  Dio? _dio;
  final NetworkConfiguration configuration;
  final AppErrorNotifier appErrorNotifier;
  final List<Interceptor> interceptors;
  final Map<String, String> _headers = {};

  Dio _getDefaultDioClient() {
    _headers.addAll(configuration.headers ?? {});
    final dio = Dio()
      ..options.baseUrl = configuration.baseUrl
      ..options.headers = _headers
      ..options.connectTimeout = const Duration(seconds: 15)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..interceptors.addAll(interceptors);

    return dio;
  }

  @override
  Future<NetworkResponse<Model>> execute<Model>(
    NetworkRequest request,
    Model Function(Map<String, dynamic>?) parser,
  ) async {
    _dio ??= _getDefaultDioClient();
    final req = PreparedNetworkRequest<Model>(
      request,
      parser,
      _dio!,
      {..._headers, ...request.headers ?? {}},
    );
    return executeRequest<Model>(req, appErrorNotifier);
  }
}

class PreparedNetworkRequest<Model> {
  const PreparedNetworkRequest(
    this.request,
    this.parser,
    this.dio,
    this.headers,
  );
  final NetworkRequest request;
  final Model Function(Map<String, dynamic>?) parser;
  final Dio dio;
  final Map<String, dynamic> headers;
}

Future<NetworkResponse<Model>> executeRequest<Model>(
  PreparedNetworkRequest<Model> request,
  AppErrorNotifier appErrorNotifier,
) async {
  try {
    final dynamic body = request.request.data.when(
      json: (data) => data.data,
      text: (data) => data.data,
      binaryData: (data) => data.data,
      formData: (data) => FormData.fromMap(data.data),
      empty: (_) => null,
    );
    final exponentialBackOff = ExponentialBackOff(
      interval: const Duration(milliseconds: 1000),
      maxAttempts: 3,
      maxRandomizationFactor: 1,
      maxDelay: const Duration(seconds: 3),
    );

    final response =
        await exponentialBackOff.start<Response<Map<String, dynamic>>>(
      () => request.dio.request<Map<String, dynamic>>(
        request.request.path,
        data: body,
        queryParameters: request.request.queryParams,
        options: Options(
          method: request.request.type.name,
          headers: request.headers,
        ),
      ),
      retryIf: (e) {
        if (e is DioException) {
          return e.response?.statusCode == 429;
        }
        return e is SocketException || e is TimeoutException;
      },
    );
    return response.fold(
      (exception) {
        throw exception;
      },
      (res) {
        return NetworkResponse.ok(
          request.parser(res.data),
        );
      },
    );
  } on DioException catch (error) {
    final errorBody = error.response?.data;
    if (error.response?.statusCode == 429) {
      return NetworkResponse.error(
        NetworkUserVisibleError(
          code: NetworkErrorCode.tooManyRequest,
          message: 'Too many requests',
        ),
      );
    }
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(
        error.response,
        StackTrace.current,
        fatal: false,
      );
    }

    if (errorBody is String) {
      return NetworkResponse.error(
        NetworkUnknownError(
          code: NetworkErrorCode.uncategorized,
          message: "Something went wrong",
        ),
      );
    }
    if (error.response?.data != null) {
      if (error.response?.statusCode == 403) {
        appErrorNotifier.notify(LeetcodeSessionExpireDialogNotification());
        return NetworkResponse.error(
          NetworkUnknownError(
            code: NetworkErrorCode.forbidden,
            message: error.response?.data?['error'],
          ),
        );
      }
      return NetworkResponse.error(
        NetworkUnknownError(
          code: NetworkErrorCode.uncategorized,
          message: "Something went wrong",
        ),
      );
    }
    if (error.error is SocketException) {
      appErrorNotifier.notify(NoInternetSnackbarNotification());
      return NetworkResponse.error(
        NetworkUnknownError(
          code: NetworkErrorCode.socketException,
          message: "No Internet",
        ),
      );
    }
    return NetworkResponse.error(
      NetworkUnknownError(
        code: NetworkErrorCode.uncategorized,
        message: "Something went wrong",
      ),
    );
  } catch (error) {
    return NetworkResponse.error(
      NetworkUnknownError(
        code: NetworkErrorCode.uncategorized,
        message: error.toString(),
      ),
    );
  }
}
