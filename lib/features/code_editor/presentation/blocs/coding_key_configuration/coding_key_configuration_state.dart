part of 'coding_key_configuration_cubit.dart';

sealed class CodingKeyConfigurationState extends Equatable {
  const CodingKeyConfigurationState();

  @override
  List<Object> get props => [];
}

final class CodingKeyConfigurationInitial extends CodingKeyConfigurationState {}

final class CodingKeyConfigurationLoading extends CodingKeyConfigurationState {}

final class CodingKeyConfigurationLoaded extends CodingKeyConfigurationState {
  final List<String> keysConfiguration;

  const CodingKeyConfigurationLoaded({required this.keysConfiguration});
}

final class CodingKeyNoUserConfiguration extends CodingKeyConfigurationState {}
