part of 'customize_coding_experience_bloc.dart';

class CustomizeCodingExperienceState extends Equatable {
  final List<({String keyId, CodingKeyConfig key})> keyConfiguration;
  final bool isCustomizing;
  final bool isReordering;
  final bool configurationLoaded;
  final ConfigurationModificationStatus modificationStatus;
  final String? editorThemeId;

  const CustomizeCodingExperienceState({
    required this.keyConfiguration,
    required this.isCustomizing,
    required this.isReordering,
    required this.configurationLoaded,
    required this.modificationStatus,
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
    );
  }

  CustomizeCodingExperienceState copyWith({
    List<({String keyId, CodingKeyConfig key})>? configuration,
    bool? isCustomizing,
    bool? isReordering,
    bool? configurationLoaded,
    ConfigurationModificationStatus? modificationStatus,
    String? editorThemeId,
  }) {
    return CustomizeCodingExperienceState(
      keyConfiguration: configuration ?? this.keyConfiguration,
      isCustomizing: isCustomizing ?? this.isCustomizing,
      isReordering: isReordering ?? this.isReordering,
      configurationLoaded: configurationLoaded ?? this.configurationLoaded,
      modificationStatus: modificationStatus ?? this.modificationStatus,
      editorThemeId: editorThemeId ?? this.editorThemeId,
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
      ];
}

enum ConfigurationModificationStatus {
  none,
  unsaved,
  saving,
  saved,
}
