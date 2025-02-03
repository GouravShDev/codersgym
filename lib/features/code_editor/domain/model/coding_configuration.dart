import 'package:codersgym/core/theme/app_code_editor_theme.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';

class CodingConfiguration {
  final String themeId;
  final List<String> keysConfigs;
  final bool darkEditorBackground;

  CodingConfiguration({
    required this.themeId,
    required this.keysConfigs,
    required this.darkEditorBackground,
  });

  CodingConfiguration copyWith({
    String? themeId,
    List<String>? keysConfigs,
    bool? darkEditorBackground,
  }) {
    return CodingConfiguration(
      themeId: themeId ?? this.themeId,
      keysConfigs: keysConfigs ?? this.keysConfigs,
      darkEditorBackground: darkEditorBackground ?? this.darkEditorBackground,
    );
  }

  factory CodingConfiguration.fromJson(Map<String, dynamic> json) {
    return CodingConfiguration(
      themeId: json['themeId'] ?? AppCodeEditorTheme.defaultThemeId,
      keysConfigs: json['keysConfigs'] != null ? List<String>.from(json['keysConfigs']) : CodingKeyConfig.defaultCodingKeyConfiguration,
      darkEditorBackground: json['darkEditorBackground'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeId': themeId,
      'keysConfigs': keysConfigs,
      'darkEditorBackground': darkEditorBackground,
    };
  }
}
