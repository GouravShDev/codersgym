abstract interface class EditorThemeConfigurationService {
  Future<String?> loadThemeConfiguration();
  Future<void> saveConfiguration(String themeId);
}
