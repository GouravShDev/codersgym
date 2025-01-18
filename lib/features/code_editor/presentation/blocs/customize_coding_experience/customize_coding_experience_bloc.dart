import 'package:bloc/bloc.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:equatable/equatable.dart';

part 'customize_coding_experience_event.dart';
part 'customize_coding_experience_state.dart';

class CustomizeCodingExperienceBloc extends Bloc<CustomizeCodingExperienceEvent, CustomizeCodingExperienceState> {
  CustomizeCodingExperienceBloc() : super(CustomizeCodingExperienceState.initial()) {
    on<CustomizeCodingExperienceEvent>((event, emit) {

    });
  }
}
