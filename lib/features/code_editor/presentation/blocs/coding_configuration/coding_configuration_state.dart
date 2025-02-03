part of 'coding_configuration_cubit.dart';

sealed class CodingConfigurationState extends Equatable {
  const CodingConfigurationState();

  @override
  List<Object> get props => [];
}

final class CodingConfigurationInitial extends CodingConfigurationState {}

final class CodingConfigurationLoading extends CodingConfigurationState {}

final class CodingConfigurationLoaded extends CodingConfigurationState {
  final CodingConfiguration configuration;

  const CodingConfigurationLoaded({required this.configuration});
}

final class CodingNoUserConfiguration extends CodingConfigurationState {}
