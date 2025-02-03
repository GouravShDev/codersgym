import 'package:bloc/bloc.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:codersgym/features/code_editor/domain/services/coding_configuration_service.dart';
import 'package:codersgym/features/code_editor/domain/services/editor_theme_configuration_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'customize_coding_experience_event.dart';
part 'customize_coding_experience_state.dart';

class CustomizeCodingExperienceBloc extends Bloc<CustomizeCodingExperienceEvent,
    CustomizeCodingExperienceState> {
  final CodingConfigurationService _service;
  CustomizeCodingExperienceBloc(
    this._service,
  ) : super(CustomizeCodingExperienceState.initial()) {
    on<CustomizeCodingExperienceEvent>((event, emit) async {
      switch (event) {
        case CustomizeCodingExperienceLoadConfiguration():
          final configuaration = await _service.loadConfiguration();
          final configurationIds = configuaration.keysConfigs;
          final themeId = configuaration.themeId;
          final configuration = configurationIds
              .map((e) => CodingKeyConfig.lookupMap[e]?.call())
              .whereType<CodingKeyConfig>()
              .map((config) => (keyId: UniqueKey().toString(), key: config))
              .toList();
          emit(
            state.copyWith(
              configuration: configuration,
              configurationLoaded: true,
              editorThemeId: themeId,
            ),
          );

        case CustomizeCodingExperienceKeySwap():
          final currentConfig =
              List<({CodingKeyConfig key, String keyId})>.from(
            state.keyConfiguration,
          );
          final item = currentConfig.removeAt(event.oldIndex);
          currentConfig.insert(event.newIndex, item);
          emit(
            state.copyWith(
              configuration: currentConfig,
              isReordering: false,
              modificationStatus: ConfigurationModificationStatus.unsaved,
            ),
          );
        case CustomizeCodingExperienceOnReorrderingStart():
          emit(
            state.copyWith(
              isReordering: true,
              modificationStatus: ConfigurationModificationStatus.unsaved,
            ),
          );
        case CustomizeCodingExperienceOnKeysEditSaveModeToggle():
          final savedMode = state.isCustomizing;
          emit(
            state.copyWith(
              isCustomizing: !state.isCustomizing,
            ),
          );
          if (savedMode) {
            add(CustomizeCodingExperienceOnSaveConfiguration());
          }

        case CustomizeCodingExperienceOnReplaceKeyConfig():
          final currentConfig =
              List<({CodingKeyConfig key, String keyId})>.from(
            state.keyConfiguration,
          );
          final replacedKey =
              CodingKeyConfig.lookupMap[event.replaceKeyId]?.call();

          if (replacedKey == null) return;
          currentConfig[event.keyIndex] = (
            key: replacedKey,
            keyId: UniqueKey().toString(),
          );
          emit(
            state.copyWith(
              configuration: currentConfig,
              modificationStatus: ConfigurationModificationStatus.unsaved,
            ),
          );
        case CustomizeCodingExperienceOnSaveConfiguration():
          emit(
            state.copyWith(
              modificationStatus: ConfigurationModificationStatus.saving,
            ),
          );
          await _service.saveConfiguration(
            state.keyConfiguration.map((e) => e.key.id).toList(),
          );
          emit(
            state.copyWith(
              modificationStatus: ConfigurationModificationStatus.saved,
            ),
          );
        case CustomizeCodingExperienceOnThemeChanged():
          // await _editorThemeService.saveThemeConfiguration(event.themeId);
          emit(
            state.copyWith(
              editorThemeId: event.themeId,
            ),
          );
      }
    });
  }
}
