import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

part 'app_file_downloader_event.dart';
part 'app_file_downloader_state.dart';

class AppFileDownloaderBloc
    extends Bloc<AppFileDownloaderEvent, AppFileDownloaderState> {
  AppFileDownloaderBloc() : super(AppFileDownloaderInitial()) {
    on<AppFileDownloaderEvent>((event, emit) async {
      switch (event) {
        case AppFileDownloadRequest():
          await _onAppFileDownloadRequest(event, emit);
          break;
        case AppFileDownloadStatusUpdate():
          _onAppFileDownloadStatusUpdate(event, emit);
      }
    });

    // FlutterDownloader.registerCallback(downloadCallback, step: 1);
    _bindBackgroundIsolate();
  }

  final ReceivePort _port = ReceivePort();
  final Map<String, String> _downloadIdToFilePathMap = {};

  static const _downloaderPortName = "downloader_send_port";

  Future<void> _onAppFileDownloadRequest(
    AppFileDownloadRequest event,
    Emitter<AppFileDownloaderState> emit,
  ) async {
    emit(AppFileIntiatingDownload());

    // Extract file name
    String fileName = Uri.parse(event.downloadUrl).pathSegments.last;
    final fileDownloadPath = await _getSaveDir();

    // Delete the file if already exists
    // It's necessary to delete the file as without deleting FlutterDownloader
    // is throwing the exception
    final file = File("$fileDownloadPath/$fileName");
    if (file.existsSync()) await file.delete();

    // final taskId = await FlutterDownloader.enqueue(
    //   url: event.downloadUrl,
    //   headers: {}, // optional: header send with url (auth token etc)
    //   savedDir: fileDownloadPath,
    //   saveInPublicStorage: false,
    //   showNotification:
    //       true, // show download progress in status bar (for Android)
    //   openFileFromNotification:
    //       true, // click on notification to open downloaded file (for Android)
    // );
    // if (taskId == null) {
    //   emit(AppFileDownloadFailed());
    //   return;
    // }
    // _downloadIdToFilePathMap[taskId] = '$fileDownloadPath/$fileName';
    // emit(
    //   AppFileOngoingDownload(
    //     downloadId: taskId,
    //     progress: 0,
    //   ),
    // );
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      _downloaderPortName,
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      // final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      // print(
      //   'Callback on UI isolate: '
      //   'task ($taskId) is in status ($status) and process ($progress)',
      // );
      final currentState = state;
      // if (currentState is AppFileOngoingDownload &&
      //     currentState.downloadId == taskId) {
      //   add(
      //     AppFileDownloadStatusUpdate(
      //       downloadId: taskId,
      //       progress: progress,
      //       status: AppFileDownloadStatus.values.byName(
      //         status.name,
      //       ),
      //     ),
      //   );
      // }
    });
  }

  Future<String> _getSaveDir() async {
    final localPath = (await _getSavedDir())!;
    final savedDir = Directory(localPath);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
    return localPath;
  }

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;
    externalStorageDirPath = (await getTemporaryDirectory()).absolute.path;

    return externalStorageDirPath;
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName(_downloaderPortName)
        ?.send([id, status, progress]);
  }

  @override
  Future<void> close() {
    _unbindBackgroundIsolate();
    _port.close();
    return super.close();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(_downloaderPortName);
  }

  void _onAppFileDownloadStatusUpdate(
    AppFileDownloadStatusUpdate event,
    Emitter<AppFileDownloaderState> emit,
  ) {
    final downloadStatus = event.status;
    switch (downloadStatus) {
      case AppFileDownloadStatus.undefined:
      // TODO: Handle this case.
      case AppFileDownloadStatus.enqueued:
      // TODO: Handle this case.
      case AppFileDownloadStatus.running:
        emit(
          AppFileOngoingDownload(
            downloadId: event.downloadId,
            progress: event.progress,
          ),
        );
        break;
      case AppFileDownloadStatus.complete:
        emit(
          AppFileDownloadCompleted(
            downloadId: event.downloadId,
          ),
        );
        // FlutterDownloader.open(taskId: event.downloadId);

        break;
      case AppFileDownloadStatus.failed:
        emit(
          AppFileDownloadFailed(),
        );

        break;
      case AppFileDownloadStatus.canceled:
        emit(
          AppFileDownloadCancelled(),
        );

        break;
      case AppFileDownloadStatus.paused:
        emit(
          AppFileDownloadPaused(
            downloadId: event.downloadId,
            progress: event.progress,
          ),
        );

        break;
    }
  }
}
