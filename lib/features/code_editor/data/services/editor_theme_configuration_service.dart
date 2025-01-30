import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/code_editor/domain/services/editor_theme_configuration_service.dart';

class EditorThemeConfigurationServiceImp
    implements EditorThemeConfigurationService {
  final StorageManager _storageManager;

  final String _key = "editor_theme_configuration";

  EditorThemeConfigurationServiceImp({required StorageManager storageManager})
      : _storageManager = storageManager;

  @override
  Future<String?> loadThemeConfiguration() {
    return _storageManager.getString(_key);
  }

  @override
  Future<void> saveConfiguration(String themeId) {
    return _storageManager.putString(_key, themeId);
  }
}
