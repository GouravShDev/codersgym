import 'package:bloc/bloc.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_configuration.dart';
import 'package:codersgym/features/code_editor/domain/services/coding_configuration_service.dart';
import 'package:equatable/equatable.dart';

part 'coding_configuration_state.dart';

class CodingKeyConfigurationCubit extends Cubit<CodingConfigurationState> {
  CodingKeyConfigurationCubit(this._service)
      : super(CodingConfigurationInitial());
  final CodingConfigurationService _service;

  Future<void> loadConfiguration() async {
    emit(CodingConfigurationLoading());
    final configuration = await _service.loadConfiguration();
    if (configuration != null) {
      emit(CodingConfigurationLoaded(configuration: configuration));
    } else {
      emit(CodingNoUserConfiguration());
    }
  }
}
