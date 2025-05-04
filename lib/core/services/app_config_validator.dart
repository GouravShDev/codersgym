/// Interface for validating a JSON object against the configuration 
/// defined by the class being imported from that JSON.
abstract interface class AppConfigValidator {
  bool isValid(Map<String, dynamic> json);
}
