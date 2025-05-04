part of 'customize_coding_experience_bloc.dart';

class CustomizeCodingExperienceState extends Equatable {
  final List<({String keyId, CodingKeyConfig key})> keyConfiguration;
  final bool isCustomizing;
  final bool isReordering;
  final bool configurationLoaded;
  final ConfigurationModificationStatus modificationStatus;
  final String? editorThemeId;
  final bool darkEditorBackground;
  final bool hideKeyboard;
  final int tabSize;
  final bool showSuggestions;
  final int fontSize;
  final ProgrammingLanguage language;

  const CustomizeCodingExperienceState({
    required this.keyConfiguration,
    required this.isCustomizing,
    required this.isReordering,
    required this.configurationLoaded,
    required this.modificationStatus,
    required this.darkEditorBackground,
    required this.hideKeyboard,
    required this.tabSize,
    required this.showSuggestions,
    required this.fontSize,
    required this.language,
    this.editorThemeId,
  });

  factory CustomizeCodingExperienceState.initial() {
    return CustomizeCodingExperienceState(
      keyConfiguration: CodingKeyConfig.defaultCodingKeyConfiguration
          .map((e) => CodingKeyConfig.lookupMap[e]?.call())
          .whereType<CodingKeyConfig>()
          .map((config) => (keyId: UniqueKey().toString(), key: config))
          .toList(),
      isCustomizing: false,
      isReordering: false,
      configurationLoaded: false,
      modificationStatus: ConfigurationModificationStatus.none,
      darkEditorBackground: CodingConfiguration.defaultDarkEditorBackground,
      hideKeyboard: CodingConfiguration.defaultHideKeyboard,
      tabSize: CodingConfiguration.defaultTabSize,
      showSuggestions: CodingConfiguration.defaultShowSuggestions,
      fontSize: CodingConfiguration.defaultFontSize,
      language: CodingConfiguration.defaultProgrammingLanguage,
    );
  }

  CustomizeCodingExperienceState copyWith({
    List<({String keyId, CodingKeyConfig key})>? keysConfiguration,
    bool? isCustomizing,
    bool? isReordering,
    bool? configurationLoaded,
    ConfigurationModificationStatus? modificationStatus,
    String? editorThemeId,
    bool? darkEditorBackground,
    bool? hideKeyboard,
    int? tabSize,
    bool? showSuggestions,
    int? fontSize,
    ProgrammingLanguage? language,
  }) {
    return CustomizeCodingExperienceState(
      keyConfiguration: keysConfiguration ?? this.keyConfiguration,
      isCustomizing: isCustomizing ?? this.isCustomizing,
      isReordering: isReordering ?? this.isReordering,
      configurationLoaded: configurationLoaded ?? this.configurationLoaded,
      modificationStatus: modificationStatus ?? this.modificationStatus,
      editorThemeId: editorThemeId ?? this.editorThemeId,
      darkEditorBackground: darkEditorBackground ?? this.darkEditorBackground,
      hideKeyboard: hideKeyboard ?? this.hideKeyboard,
      tabSize: tabSize ?? this.tabSize,
      showSuggestions: showSuggestions ?? this.showSuggestions,
      fontSize: fontSize ?? this.fontSize,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        keyConfiguration,
        isCustomizing,
        isReordering,
        configurationLoaded,
        modificationStatus,
        editorThemeId,
        darkEditorBackground,
        hideKeyboard,
        tabSize,
        showSuggestions,
        fontSize,
        language,
      ];
}

enum ConfigurationModificationStatus {
  none,
  unsaved,
  saving,
  saved,
}
