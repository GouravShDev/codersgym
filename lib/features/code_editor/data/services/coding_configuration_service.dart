import 'package:codersgym/core/theme/app_code_editor_theme.dart';
import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_configuration.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/domain/services/coding_configuration_service.dart';

class CodingConfigurationServiceImp implements CodingConfigurationService {
  final StorageManager _storageManager;

  final String _key = "coding_keys_configuration";

  /// This needs to be migrate to configuration
  final String _preferedCodingLanguageOldKey = 'preferedCodingLang';

  CodingConfigurationServiceImp({required StorageManager storageManager})
      : _storageManager = storageManager;

  @override
  Future<CodingConfiguration> loadConfiguration() async {
    final lastSelectedLanguage =
        await _storageManager.getString(_preferedCodingLanguageOldKey);
    final config = await _storageManager.getObjectMap(_key);
    if (config == null) {
      return CodingConfiguration(
        themeId: AppCodeEditorTheme.defaultThemeId,
        keysConfigs: CodingKeyConfig.defaultCodingKeyConfiguration,
        darkEditorBackground: CodingConfiguration.defaultDarkEditorBackground,
        language: lastSelectedLanguage != null
            ? ProgrammingLanguage.values.byName(lastSelectedLanguage)
            : ProgrammingLanguage.cpp,
      );
    }
    // Migrating old language to coding config json
    if (config['language'] == null) config['language'] = lastSelectedLanguage;
    return CodingConfiguration.fromJson(config);
  }

  @override
  Future<void> saveConfiguration(CodingConfiguration configs) {
    return _storageManager.putObjectMp(_key, configs.toJson());
  }
}
