import 'package:codersgym/core/services/app_file_reader.dart';
import 'package:codersgym/core/services/app_file_writer.dart';

/// Service class that manages configuration import and export functionality
class AppConfigService {
  final AppFileWriter _writer;
  final AppFileReader _reader;

  /// Current app configuration
  Map<String, dynamic> _currentConfig = {};

  /// Constructor that initializes with default writer and reader
  AppConfigService({
    required AppFileWriter writer,
    required AppFileReader reader,
  })  : _writer = writer,
        _reader = reader;

  /// Get the current configuration
  Map<String, dynamic> get currentConfig => _currentConfig;

  /// Set the current configuration
  set currentConfig(Map<String, dynamic> value) {
    _currentConfig = value;
  }

  /// Export the current configuration to a file
  Future<void> exportCurrentConfig() async {
    return await _writer.exportConfig(_currentConfig);
  }

  /// Import configuration from a file and update current configuration
  ///
  /// Returns a [Future<bool>] indicating success (true) or failure (false)
  Future<bool> importAndUpdateConfig() async {
    final importedConfig = await _reader.importConfig();

    if (importedConfig != null) {
      _currentConfig = importedConfig;
      return true;
    }

    return false;
  }

  /// Export a specific configuration to a file
  ///
  /// [config] - The configuration to export
  Future<void> exportSpecificConfig(Map<String, dynamic> config) async {
    return await _writer.exportConfig(config);
  }
}
