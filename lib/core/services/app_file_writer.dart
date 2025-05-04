import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class AppFileWriter {
  /// Exports the provided configuration data to a file selected by the user
  /// Throws [AppFileWriteException] on failure
  Future<void> exportConfig(Map<String, dynamic> configData) async {
    try {
      // Convert the configuration to JSON
      String jsonData;
      try {
        jsonData = jsonEncode(configData);
      } catch (e) {
        throw JsonEncodingFailed();
      }

      // Open file picker to let user choose where to save the file
      String? saveDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Choose where to save your configuration',
      );

      // User cancelled the picker
      if (saveDirectory == null) {
        throw FileSaveCancelledByUser();
      }

      // Create file path with default name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = path.join(saveDirectory, 'app_config_$timestamp.json');

      // Write the data to the file
      File file = File(filePath);
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
      await file.writeAsString(jsonData);
    } on AppFileWriteException {
      rethrow;
    } on FileSystemException catch (e) {
      if (e.osError?.errorCode == 13) { // Permission denied
        throw FileWritePermissionDenied();
      } else {
        throw UnknownFileWriteError(e.message);
      }
    } catch (e) {
      throw UnknownFileWriteError(e.toString());
    }
  }
}


sealed class AppFileWriteException {}

class FileSaveCancelledByUser extends AppFileWriteException {}

class FileWritePermissionDenied extends AppFileWriteException {}

class JsonEncodingFailed extends AppFileWriteException {}

class UnknownFileWriteError extends AppFileWriteException {
  final String message;
  UnknownFileWriteError(this.message);
}
