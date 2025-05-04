import 'package:bloc/bloc.dart';
import 'package:codersgym/core/services/app_file_writer.dart';
import 'package:codersgym/features/code_editor/data/services/app_config_service.dart';
import 'package:equatable/equatable.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_configuration.dart';

part 'code_configuration_exporter_state.dart';

class CodeConfigurationExporterCubit
    extends Cubit<CodeConfigurationExporterState> {
  final AppConfigService _appConfigService;
  CodeConfigurationExporterCubit(this._appConfigService)
      : super(CodeConfigurationExporterInitial());

  Future<void> exportConfiguration(CodingConfiguration config) async {
    emit(CodeConfigurationExporting());
    try {
      _appConfigService.currentConfig = config.toJson();
      await _appConfigService.exportCurrentConfig();

      emit(
        CodeConfigurationExported(),
      );
    } on FileSaveCancelledByUser {
      emit(CodeConfigurationExporterInitial()); // Back to idle state silently
    } on JsonEncodingFailed {
      emit(
        const CodeConfigurationExportFailed(
            "Failed to encode configuration to JSON."),
      );
    } on FileWritePermissionDenied {
      emit(
        const CodeConfigurationExportFailed(
            "Permission denied while saving the file."),
      );
    } on UnknownFileWriteError catch (e) {
      emit(
        CodeConfigurationExportFailed("Unexpected error: ${e.message}"),
      );
    } catch (e) {
      emit(
        const CodeConfigurationExportFailed(
            "Unknown error occurred during export."),
      );
    }
  }
}
