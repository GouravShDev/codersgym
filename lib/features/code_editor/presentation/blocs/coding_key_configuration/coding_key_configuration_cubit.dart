import 'package:bloc/bloc.dart';
import 'package:codersgym/features/code_editor/domain/services/coding_key_configuration_service.dart';
import 'package:equatable/equatable.dart';

part 'coding_key_configuration_state.dart';

class CodingKeyConfigurationCubit extends Cubit<CodingKeyConfigurationState> {
  CodingKeyConfigurationCubit(this._service)
      : super(CodingKeyConfigurationInitial());
  final CodingKeyConfigurationService _service;

  Future<void> loadConfiguration() async {
    emit(CodingKeyConfigurationLoading());
    final configuration = await _service.loadConfiguration();
    if (configuration != null) {
      emit(CodingKeyConfigurationLoaded(keysConfiguration: configuration));
    } else {
      emit(CodingKeyNoUserConfiguration());
    }
  }
}
