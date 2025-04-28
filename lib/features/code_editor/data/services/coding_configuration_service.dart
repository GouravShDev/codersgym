import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_configuration.dart';
import 'package:codersgym/features/code_editor/domain/services/coding_configuration_service.dart';

class CodingConfigurationServiceImp implements CodingConfigurationService {
  final StorageManager _storageManager;

  final String _key = "coding_keys_configuration";

  CodingConfigurationServiceImp({required StorageManager storageManager})
      : _storageManager = storageManager;

  @override
  Future<CodingConfiguration?> loadConfiguration() async {
    final config = await _storageManager.getObjectMap(_key);
    if (config == null) return null;
    return CodingConfiguration.fromJson(config);
  }

  @override
  Future<void> saveConfiguration(CodingConfiguration configs) {
    return _storageManager.putObjectMp(_key, configs.toJson());
  }
}
