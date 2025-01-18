import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/code_editor/domain/services/coding_key_configuration_service.dart';

class CodingKeyConfigurationServiceImp
    implements CodingKeyConfigurationService {
  final StorageManager _storageManager;

  final String _key = "coding_keys_configuration";

  CodingKeyConfigurationServiceImp({required StorageManager storageManager})
      : _storageManager = storageManager;

  @override
  Future<List<String>?> loadConfiguration() {
    return _storageManager.getStringList(_key);
  }

  @override
  Future<void> saveConfiguration(List<String> configs) {
    return _storageManager.putStringList(_key, configs);
  }
}
