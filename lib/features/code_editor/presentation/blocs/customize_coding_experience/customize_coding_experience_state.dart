part of 'customize_coding_experience_bloc.dart';

class CustomizeCodingExperienceState extends Equatable {
  final List<({String keyId, CodingKeyConfig key})> configuration;
  final bool isCustomizing;
  final bool isReordering;
  final bool configurationLoaded;
  final ConfigurationModificationStatus modificationStatus;

  const CustomizeCodingExperienceState({
    required this.configuration,
    required this.isCustomizing,
    required this.isReordering,
    required this.configurationLoaded,
    required this.modificationStatus,
  });

  factory CustomizeCodingExperienceState.initial() {
    return CustomizeCodingExperienceState(
      configuration: CodingKeyConfig.defaultCodingKeyConfiguration
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
  }) {
    return CustomizeCodingExperienceState(
      configuration: configuration ?? this.configuration,
      isCustomizing: isCustomizing ?? this.isCustomizing,
      isReordering: isReordering ?? this.isReordering,
      configurationLoaded: configurationLoaded ?? this.configurationLoaded,
      modificationStatus: modificationStatus ?? this.modificationStatus,
    );
  }

  @override
  List<Object> get props => [
        configuration,
        isCustomizing,
        isReordering,
        configurationLoaded,
        modificationStatus,
      ];
}

enum ConfigurationModificationStatus {
  none,
  unsaved,
  saving,
  saved,
}
