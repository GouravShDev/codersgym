part of 'code_configuration_exporter_cubit.dart';

sealed class CodeConfigurationExporterState extends Equatable {
  const CodeConfigurationExporterState();

  @override
  List<Object> get props => [];
}

final class CodeConfigurationExporterInitial extends CodeConfigurationExporterState {}

final class CodeConfigurationExporting extends CodeConfigurationExporterState {}

final class CodeConfigurationExported extends CodeConfigurationExporterState {}

final class CodeConfigurationExportFailed extends CodeConfigurationExporterState {
  final String message;
  const CodeConfigurationExportFailed(this.message);
}