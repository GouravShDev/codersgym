import 'dart:convert';
import 'dart:io';

import 'package:codersgym/core/services/app_config_validator.dart';
import 'package:file_picker/file_picker.dart';

/// Class responsible for reading app configuration from files
class AppFileReader {
  /// Required for validating the configuration in the file
  final AppConfigValidator _configValidator;

  AppFileReader(this._configValidator);

  /// Imports configuration data from a file selected by the user
  ///
  /// Returns a [Future<Map<String, dynamic>?>] with the configuration data or throws an [AppFileReaderException]
  Future<Map<String, dynamic>> importConfig() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        // allowedExtensions: ['json'],
        dialogTitle: 'Select configuration file to import',
      );

      if (result == null || result.files.isEmpty) {
        throw FileReadCancelledByUser();
      }

      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();

      final parsedJson = jsonDecode(jsonString);

      if (parsedJson is! Map<String, dynamic>) {
        throw InvalidJsonStructure();
      }

      final configData = parsedJson;

      if (!_configValidator.isValid(configData)) {
        throw InvalidConfigurationFile();
      }

      return configData;
    } on AppFileReaderException {
      rethrow; // Already a known custom exception
    } on FormatException {
      throw InvalidJsonStructure(); // Covers malformed JSON
    } catch (e) {
      throw UnknownFileReadError(e.toString());
    }
  }
}

sealed class AppFileReaderException {}

class FileReadCancelledByUser extends AppFileReaderException {}

class InvalidConfigurationFile extends AppFileReaderException {}

class InvalidJsonStructure extends AppFileReaderException {}

class UnknownFileReadError extends AppFileReaderException {
  final String message;
  UnknownFileReadError(this.message);
}
