import 'package:bloc/bloc.dart';
import 'package:codersgym/core/services/app_file_reader.dart';
import 'package:codersgym/features/code_editor/data/services/app_config_service.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_configuration.dart';
import 'package:equatable/equatable.dart';

part 'code_configuration_importer_state.dart';

class CodeConfigurationImporterCubit
    extends Cubit<CodeConfigurationImporterState> {
  CodeConfigurationImporterCubit(
    this._appConfigService,
  ) : super(CodeConfigurationImporterInitial());
  final AppConfigService _appConfigService;

  Future<void> importConfiguration() async {
    emit(CodeConfigurationImporting());
    try {
      await _appConfigService.importAndUpdateConfig();
      final configJson = _appConfigService.currentConfig;
      emit(
        CodeConfigurationImportSuccess(
          CodingConfiguration.fromJson(
            configJson,
          ),
        ),
      );
    } catch (e) {
      if (e is FileReadCancelledByUser) {
        emit(CodeConfigurationImporterInitial());
        return;
      }
      if (e is InvalidJsonStructure) {
        emit(CodeConfigurationImportFailed(
            "The selected file has an invalid JSON format."));
        return;
      }
      if (e is InvalidConfigurationFile) {
        emit(CodeConfigurationImportFailed(
            "The file does not match the expected configuration format."));
        return;
      }
      if (e is UnknownFileReadError) {
        emit(CodeConfigurationImportFailed(
            "An unexpected error occurred: ${e.message}"));
        return;
      }
      emit(CodeConfigurationImportFailed(
          "Import failed due to an unknown error. Please try again."));
    }
  }
}
