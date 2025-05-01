import 'dart:typed_data';

abstract class NetworkService {
  Future<NetworkResponse<Model>> execute<Model>(
    NetworkRequest request,
    Model Function(Map<String, dynamic>?) parser,
  );
}

class NetworkResponse<Model> {
  final Model? data;
  final NetworkError? error;

  NetworkResponse.ok(this.data) : error = null;
  NetworkResponse.error(this.error) : data = null;

  bool get isSuccess => error == null;

  T when<T>({
    required T Function(Model data) ok,
    required T Function(NetworkError error) error,
  }) {
    if (isSuccess && data != null) {
      return ok(data as Model);
    } else if (this.error != null) {
      return error(this.error!);
    } else {
      throw Exception(" NetworkResponse is in an invalid state");
    }
  }
}

enum NetworkRequestType { get, post, put, patch, delete }

class NetworkRequest {
  final NetworkRequestType type;
  final String path;
  final NetworkRequestBody data;
  final Map<String, dynamic>? queryParams;
  final Map<String, String>? headers;

  const NetworkRequest({
    required this.type,
    required this.path,
    required this.data,
    this.queryParams,
    this.headers,
  });
}

abstract class NetworkRequestBody {
  const NetworkRequestBody();

  factory NetworkRequestBody.empty() = NetworkRequestBodyEmpty;
  factory NetworkRequestBody.json(Map<String, dynamic> data) =
      NetworkRequestBodyJson;
  factory NetworkRequestBody.formData(Map<String, dynamic> data) =
      NetworkRequestBodyFormData;
  factory NetworkRequestBody.binaryData(Uint8List data) =
      NetworkRequestBodyBinaryData;
  factory NetworkRequestBody.text(String data) = NetworkRequestBodyText;

  T when<T>({
    required T Function(NetworkRequestBodyEmpty) empty,
    required T Function(NetworkRequestBodyJson) json,
    required T Function(NetworkRequestBodyFormData) formData,
    required T Function(NetworkRequestBodyBinaryData) binaryData,
    required T Function(NetworkRequestBodyText) text,
  }) {
    if (this is NetworkRequestBodyEmpty) {
      return empty(this as NetworkRequestBodyEmpty);
    } else if (this is NetworkRequestBodyJson) {
      return json(this as NetworkRequestBodyJson);
    } else if (this is NetworkRequestBodyFormData) {
      return formData(this as NetworkRequestBodyFormData);
    } else if (this is NetworkRequestBodyBinaryData) {
      return binaryData(this as NetworkRequestBodyBinaryData);
    } else if (this is NetworkRequestBodyText) {
      return text(this as NetworkRequestBodyText);
    } else {
      throw UnsupportedError("Unknown NetworkRequestBody type: $this");
    }
  }
}

class NetworkRequestBodyEmpty extends NetworkRequestBody {}

class NetworkRequestBodyJson extends NetworkRequestBody {
  final Map<String, dynamic> data;
  NetworkRequestBodyJson(this.data);
}

class NetworkRequestBodyFormData extends NetworkRequestBody {
  final Map<String, dynamic> data;
  NetworkRequestBodyFormData(this.data);
}

class NetworkRequestBodyBinaryData extends NetworkRequestBody {
  final Uint8List data;
  NetworkRequestBodyBinaryData(this.data);
}

class NetworkRequestBodyText extends NetworkRequestBody {
  final String data;
  NetworkRequestBodyText(this.data);
}

class NetworkConfiguration {
  final String baseUrl;
  final Map<String, String>? headers;

  NetworkConfiguration({required this.baseUrl, this.headers});
}

abstract class NetworkError {
  final NetworkErrorCode? code;
  final String? message;

  NetworkError({this.code, required this.message});

  factory NetworkError.fromJson(Map<String, dynamic> json) {
    final codeString = json['code'] as String?;
    final errorMessage = json['message'] as String?;
    if (codeString == "INTERNAL_SERVER_ERROR") {
      return NetworkUnknownError(message: errorMessage);
    }
    final errorCode = NetworkErrorCode.fromJson(codeString);

    return NetworkUserVisibleError(code: errorCode, message: errorMessage);
  }
  @override
  String toString() {
    return 'NetworkError{code: $code, message: $message}';
  }
}

class NetworkUserVisibleError extends NetworkError {
  NetworkUserVisibleError({super.code, required super.message});
}

class NetworkUnknownError extends NetworkError {
  NetworkUnknownError({super.code, required super.message});
}

enum NetworkErrorCode {
  socketException,
  forbidden,
  uncategorized,
  tooManyRequest;

  String toJson() => name;

  static NetworkErrorCode fromJson(String? json) => json != null
      ? NetworkErrorCode.values.byName(json)
      : NetworkErrorCode.uncategorized;
}
