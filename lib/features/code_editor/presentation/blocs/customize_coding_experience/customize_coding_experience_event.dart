part of 'customize_coding_experience_bloc.dart';

sealed class CustomizeCodingExperienceEvent extends Equatable {
  const CustomizeCodingExperienceEvent();

  @override
  List<Object> get props => [];
}

class CustomizeCodingExperienceLoadConfiguration
    extends CustomizeCodingExperienceEvent {}

class CustomizeCodingExperienceKeySwap extends CustomizeCodingExperienceEvent {
  final int oldIndex;
  final int newIndex;

  const CustomizeCodingExperienceKeySwap({
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class CustomizeCodingExperienceOnReorrderingStart
    extends CustomizeCodingExperienceEvent {}

class CustomizeCodingExperienceOnKeysModifyPreviewModeToggle
    extends CustomizeCodingExperienceEvent {}

class CustomizeCodingExperienceOnSaveConfiguration
    extends CustomizeCodingExperienceEvent {}

class CustomizeCodingExperienceOnReplaceKeyConfig
    extends CustomizeCodingExperienceEvent {
  final int keyIndex;
  final String replaceKeyId;

  const CustomizeCodingExperienceOnReplaceKeyConfig({
    required this.keyIndex,
    required this.replaceKeyId,
  });
}

class CustomizeCodingExperienceOnThemeChanged
    extends CustomizeCodingExperienceEvent {
  final String themeId;

  CustomizeCodingExperienceOnThemeChanged(
    this.themeId,
  );
}

class CustomizeCodingExperienceOnDarkEditorBackgroundToggle
    extends CustomizeCodingExperienceEvent {}

class CustomizeCodingExperienceOnPreferenceChanged
    extends CustomizeCodingExperienceEvent {
  final bool? hideKeyboard;
  final int? tabSize;
  final bool? showSuggestions;
  final int? fontSize;
  final ProgrammingLanguage? language;

  const CustomizeCodingExperienceOnPreferenceChanged({
    this.hideKeyboard,
    this.tabSize,
    this.showSuggestions,
    this.fontSize,
    this.language,
  });
}

class CustomizeCodingExperienceOnConfigurationImport
    extends CustomizeCodingExperienceEvent {
  final CodingConfiguration configuration;

  const CustomizeCodingExperienceOnConfigurationImport(this.configuration);
}
