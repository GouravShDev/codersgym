import 'package:codersgym/core/services/app_config_validator.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_configuration.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';

class CodingConfigurationValidator implements AppConfigValidator {
  @override
  bool isValid(Map<String, dynamic> json) {
    try {
      if (json['themeId'] != null && json['themeId'] is! String) return false;

      if (json['keysConfigs'] != null) {
        if (json['keysConfigs'] is! List) return false;
        if (!json['keysConfigs'].every((element) => element is String)) {
          return false;
        }
      }

      if (json['darkEditorBackground'] != null &&
          json['darkEditorBackground'] is! bool) {
        return false;
      }

      if (json['hideKeyboard'] != null && json['hideKeyboard'] is! bool) {
        return false;
      }

      if (json['tabSize'] != null && json['tabSize'] is! int) return false;

      if (json['showSuggestions'] != null && json['showSuggestions'] is! bool) {
        return false;
      }

      if (json['fontSize'] != null && json['fontSize'] is! int) return false;

      if (json['language'] != null) {
        final lang = json['language'];
        if (lang is! String ||
            !ProgrammingLanguage.values.map((e) => e.name).contains(lang)) {
          return false;
        }
      }

      CodingConfiguration.fromJson(json);
      return true;
    } catch (e) {
      return false;
    }
  }
}
