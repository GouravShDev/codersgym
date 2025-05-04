part of 'code_configuration_importer_cubit.dart';

sealed class CodeConfigurationImporterState extends Equatable {
  const CodeConfigurationImporterState();

  @override
  List<Object> get props => [];
}

final class CodeConfigurationImporterInitial
    extends CodeConfigurationImporterState {}

final class CodeConfigurationImporting extends CodeConfigurationImporterState {}

final class CodeConfigurationImportSuccess
    extends CodeConfigurationImporterState {
  final CodingConfiguration configuration;

  const CodeConfigurationImportSuccess(this.configuration);
  @override
  List<Object> get props => [configuration];
}

final class CodeConfigurationImportFailed
    extends CodeConfigurationImporterState {
  final String message;

  const CodeConfigurationImportFailed(
    this.message,
  );
}
