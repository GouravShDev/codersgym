import 'package:bloc/bloc.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_configuration.dart';
import 'package:codersgym/features/code_editor/domain/services/coding_configuration_service.dart';
import 'package:equatable/equatable.dart';

part 'coding_configuration_state.dart';

class CodingConfigurationCubit extends Cubit<CodingConfigurationState> {
  CodingConfigurationCubit(this._service) : super(CodingConfigurationInitial());
  final CodingConfigurationService _service;

  Future<void> loadConfiguration() async {
    emit(CodingConfigurationLoading());
    final configuration = await _service.loadConfiguration();
    emit(CodingConfigurationLoaded(configuration: configuration));
  }
}
