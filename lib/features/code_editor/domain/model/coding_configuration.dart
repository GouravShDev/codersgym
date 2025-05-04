import 'package:codersgym/core/theme/app_code_editor_theme.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';

class CodingConfiguration {
  static const bool defaultHideKeyboard = false;
  static const int defaultTabSize = 2;
  static const bool defaultShowSuggestions = true;
  static const int defaultFontSize = 16;
  static const bool defaultDarkEditorBackground = true;
  static const ProgrammingLanguage defaultProgrammingLanguage =
      ProgrammingLanguage.cpp;

  final String themeId;
  final List<String> keysConfigs;
  final bool darkEditorBackground;
  final bool hideKeyboard;
  final int tabSize;
  final bool showSuggestions;
  final int fontSize;
  final ProgrammingLanguage language;

  CodingConfiguration({
    required this.themeId,
    required this.keysConfigs,
    required this.darkEditorBackground,
    this.hideKeyboard = defaultHideKeyboard,
    this.tabSize = defaultTabSize,
    this.showSuggestions = defaultShowSuggestions,
    this.fontSize = defaultFontSize,
    this.language = defaultProgrammingLanguage,
  });

  CodingConfiguration copyWith({
    String? themeId,
    List<String>? keysConfigs,
    bool? darkEditorBackground,
    bool? hideKeyboard,
    int? tabSize,
    bool? showSuggestions,
    int? fontSize,
    ProgrammingLanguage? language,
  }) {
    return CodingConfiguration(
      themeId: themeId ?? this.themeId,
      keysConfigs: keysConfigs ?? this.keysConfigs,
      darkEditorBackground: darkEditorBackground ?? this.darkEditorBackground,
      hideKeyboard: hideKeyboard ?? this.hideKeyboard,
      tabSize: tabSize ?? this.tabSize,
      showSuggestions: showSuggestions ?? this.showSuggestions,
      fontSize: fontSize ?? this.fontSize,
      language: language ?? this.language,
    );
  }

  factory CodingConfiguration.fromJson(Map<String, dynamic> json) {
    return CodingConfiguration(
      themeId: json['themeId'] ?? AppCodeEditorTheme.defaultThemeId,
      keysConfigs: json['keysConfigs'] != null
          ? List<String>.from(json['keysConfigs'])
          : CodingKeyConfig.defaultCodingKeyConfiguration,
      darkEditorBackground:
          json['darkEditorBackground'] ?? defaultDarkEditorBackground,
      hideKeyboard: json['hideKeyboard'] ?? defaultHideKeyboard,
      tabSize: json['tabSize'] ?? defaultTabSize,
      showSuggestions: json['showSuggestions'] ?? defaultShowSuggestions,
      fontSize: json['fontSize'] ?? defaultFontSize,
      language: json['language'] != null
          ? ProgrammingLanguage.values.byName(json['language'])
          : defaultProgrammingLanguage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeId': themeId,
      'keysConfigs': keysConfigs,
      'darkEditorBackground': darkEditorBackground,
      'hideKeyboard': hideKeyboard,
      'tabSize': tabSize,
      'showSuggestions': showSuggestions,
      'fontSize': fontSize,
      'language': language.name,
    };
  }

  /// Keys for validating the json from the user
  /// list of keys which are essestial for the import to
  /// be succesful
  static const List<String> requiredKeys = [];
}
