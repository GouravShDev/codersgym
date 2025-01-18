part of 'customize_coding_experience_bloc.dart';

class CustomizeCodingExperienceState extends Equatable {
  final List<CodingKeyConfig> configuration;
  final bool isCustomizing;
  const CustomizeCodingExperienceState({
    required this.configuration,
    required this.isCustomizing,
  });

  factory CustomizeCodingExperienceState.initial() {
    return CustomizeCodingExperienceState(
      configuration: CodingKeyConfig.defaultCodingKeyConfiguration
          .map(
            (e) => CodingKeyConfig.lookupMap[e]?.call(),
          )
          .whereType<CodingKeyConfig>()
          .toList(),
      isCustomizing: false,
    );
  }

  @override
  List<Object> get props => [configuration, isCustomizing];
}
