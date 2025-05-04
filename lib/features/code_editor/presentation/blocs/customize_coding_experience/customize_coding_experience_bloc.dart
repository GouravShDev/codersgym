import 'package:bloc/bloc.dart';
import 'package:codersgym/core/theme/app_code_editor_theme.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_configuration.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/domain/services/coding_configuration_service.dart';
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
          final codingConfiguration = await _service.loadConfiguration() ??
              CodingConfiguration(
                themeId: AppCodeEditorTheme.defaultThemeId,
                keysConfigs: CodingKeyConfig.defaultCodingKeyConfiguration,
                darkEditorBackground:
                    CodingConfiguration.defaultDarkEditorBackground,
              );
          _loadingConfiguration(
            codingConfiguration: codingConfiguration,
            emit: emit,
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
              keysConfiguration: currentConfig,
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
        case CustomizeCodingExperienceOnKeysModifyPreviewModeToggle():
          emit(
            state.copyWith(
              isCustomizing: !state.isCustomizing,
            ),
          );

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
              keysConfiguration: currentConfig,
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
            state.toConfiguration(),
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
              modificationStatus: ConfigurationModificationStatus.unsaved,
            ),
          );
        case CustomizeCodingExperienceOnDarkEditorBackgroundToggle():
          emit(
            state.copyWith(
              darkEditorBackground: !state.darkEditorBackground,
              modificationStatus: ConfigurationModificationStatus.unsaved,
            ),
          );
        case CustomizeCodingExperienceOnPreferenceChanged():
          emit(
            state.copyWith(
              fontSize: event.fontSize,
              hideKeyboard: event.hideKeyboard,
              showSuggestions: event.showSuggestions,
              tabSize: event.tabSize,
              modificationStatus: ConfigurationModificationStatus.unsaved,
              language: event.language,
            ),
          );
        case CustomizeCodingExperienceOnConfigurationImport():
          _loadingConfiguration(
            codingConfiguration: event.configuration,
            status: ConfigurationModificationStatus.unsaved,
            emit: emit,
          );
      }
    });
  }

  void _loadingConfiguration({
    required CodingConfiguration codingConfiguration,
    ConfigurationModificationStatus? status,
    required Emitter<CustomizeCodingExperienceState> emit,
  }) {
    final configurationIds = codingConfiguration.keysConfigs;
    final themeId = codingConfiguration.themeId;
    final keyConfiguration = configurationIds
        .map((e) => CodingKeyConfig.lookupMap[e]?.call())
        .whereType<CodingKeyConfig>()
        .map((config) => (keyId: UniqueKey().toString(), key: config))
        .toList();
    emit(
      state.copyWith(
        keysConfiguration: keyConfiguration,
        configurationLoaded: true,
        editorThemeId: themeId,
        darkEditorBackground: codingConfiguration.darkEditorBackground,
        fontSize: codingConfiguration.fontSize,
        hideKeyboard: codingConfiguration.hideKeyboard,
        showSuggestions: codingConfiguration.showSuggestions,
        tabSize: codingConfiguration.tabSize,
        language: codingConfiguration.language,
        modificationStatus: status,
      ),
    );
  }
}

extension CodingConfigurationExt on CustomizeCodingExperienceState {
  CodingConfiguration toConfiguration() {
    return CodingConfiguration(
      themeId: editorThemeId ?? '',
      keysConfigs: keyConfiguration.map((e) => e.key.id).toList(),
      darkEditorBackground: darkEditorBackground,
      fontSize: fontSize,
      hideKeyboard: hideKeyboard,
      showSuggestions: showSuggestions,
      tabSize: tabSize,
      language: language,
    );
  }
}
