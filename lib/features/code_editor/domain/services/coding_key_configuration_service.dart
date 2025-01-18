abstract interface class CodingKeyConfigurationService {
  Future<List<String>?> loadConfiguration();
  Future<void> saveConfiguration(List<String> configs);
}
