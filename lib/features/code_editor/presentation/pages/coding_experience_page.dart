import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/theme/app_code_editor_theme.dart';
import 'package:codersgym/features/code_editor/data/services/app_config_service.dart';
import 'package:codersgym/features/code_editor/domain/model/code_experience_sample_code.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/domain/services/coding_configuration_validator.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_configuration_exporter/code_configuration_exporter_cubit.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_configuration_importer_cubit/code_configuration_importer_cubit.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/customize_coding_experience/customize_coding_experience_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/code_editor_theme_picker_bottomsheet.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/customizable_coding_keys.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/preference_bottomsheet.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/save_configuration_dialog.dart';
import 'package:codersgym/features/common/widgets/app_code_editor_field.dart';
import 'package:codersgym/features/common/widgets/app_snackbar.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

@RoutePage()
class CodingExperiencePage extends StatelessWidget implements AutoRouteWrapper {
  const CodingExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final codeExpBloc = context.read<CustomizeCodingExperienceBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize Experience"),
        actions: [
          BlocBuilder<CustomizeCodingExperienceBloc,
              CustomizeCodingExperienceState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: state.modificationStatus ==
                          ConfigurationModificationStatus.unsaved
                      ? () {
                          codeExpBloc.add(
                            CustomizeCodingExperienceOnSaveConfiguration(),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text("Save"),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<CustomizeCodingExperienceBloc,
          CustomizeCodingExperienceState>(
        buildWhen: (prev, next) =>
            prev.isCustomizing != next.isCustomizing ||
            prev.hideKeyboard != next.hideKeyboard,
        builder: (context, state) {
          return AnimatedPadding(
            padding: EdgeInsets.only(
              bottom:
                  (state.hideKeyboard) ? 0 : (state.isCustomizing ? 280 : 120),
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastEaseInToSlowEaseOut,
            child: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              overlayOpacity: 0.4,
              onOpen: () {
                FocusScope.of(context).unfocus();
              },
              spacing: 12,
              spaceBetweenChildren: 8,
              children: [
                buildSpeedDialChild(
                  context: context,
                  icon: Icons.color_lens_rounded,
                  label: 'Theme',
                  iconColor: Colors.deepOrange,
                  onTap: () {
                    _onCustomizeTheme(context);
                  },
                ),
                buildSpeedDialChild(
                  context: context,
                  icon: Icons.tune,
                  label: 'Preference',
                  iconColor: Colors.amberAccent,
                  onTap: () {
                    final state =
                        context.read<CustomizeCodingExperienceBloc>().state;
                    showEditorPreferences(
                      context,
                      onPreferenceChanged: ({
                        bool? hideKeyboard,
                        int? tabSize,
                        bool? showSuggestions,
                        int? fontSize,
                        ProgrammingLanguage? language,
                      }) {
                        context.read<CustomizeCodingExperienceBloc>().add(
                              CustomizeCodingExperienceOnPreferenceChanged(
                                fontSize: fontSize,
                                hideKeyboard: hideKeyboard,
                                tabSize: tabSize,
                                showSuggestions: showSuggestions,
                                language: language,
                              ),
                            );
                      },
                      initialHideKeyboard: state.hideKeyboard,
                      initialShowSuggestions: state.showSuggestions,
                      initialTabSize: state.tabSize,
                      fontSize: state.fontSize,
                      language: state.language,
                    );
                  },
                ),
                buildSpeedDialChild(
                  context: context,
                  icon: Icons.cloud_upload,
                  label: 'Export Config',
                  iconColor: Colors.green,
                  onTap: () {
                    debugPrint('Export Configuration selected');
                    context
                        .read<CodeConfigurationExporterCubit>()
                        .exportConfiguration(
                          codeExpBloc.state.toConfiguration(),
                        );
                  },
                ),
                buildSpeedDialChild(
                  context: context,
                  icon: Icons.download,
                  label: 'Import Config',
                  iconColor: Colors.lightBlue,
                  onTap: () {
                    debugPrint('Import Configuration selected');
                    context
                        .read<CodeConfigurationImporterCubit>()
                        .importConfiguration();
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CodeConfigurationImporterCubit,
              CodeConfigurationImporterState>(
            listener: (context, state) {
              if (state is CodeConfigurationImportSuccess) {
                codeExpBloc.add(
                  CustomizeCodingExperienceOnConfigurationImport(
                    state.configuration,
                  ),
                );
              }
              final (message, status) = switch (state) {
                CodeConfigurationImportSuccess() => (
                    "Configuration imported successfully!",
                    SnackbarType.success
                  ),
                CodeConfigurationImportFailed() => (
                    state.message,
                    SnackbarType.error
                  ),
                _ => (null, null),
              };
              if (message != null && status != null) {
                AppSnackbar.show(
                  context: context,
                  message: message,
                  type: status,
                );
              }
            },
          ),
          BlocListener<CodeConfigurationExporterCubit,
              CodeConfigurationExporterState>(
            listener: (context, state) {
              final (message, status) = switch (state) {
                CodeConfigurationExported() => (
                    "Configuration exported successfully!",
                    SnackbarType.success
                  ),
                CodeConfigurationExportFailed() => (
                    "${state.message}. Please try again.",
                    SnackbarType.error
                  ),
                _ => (null, null),
              };
              if (message != null && status != null) {
                AppSnackbar.show(
                  context: context,
                  message: message,
                  type: status,
                );
              }
            },
          ),
        ],
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, __) async {
            if (didPop) {
              return;
            }
            if (codeExpBloc.state.modificationStatus !=
                ConfigurationModificationStatus.unsaved) {
              Navigator.pop(context);
              return;
            }
            final shouldGoBack = await SaveConfigurationDialog.show(context) ??
                false; // Default to staying on the page if the dialog is dismissed
            if (!shouldGoBack) {
              return;
            }
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: SafeArea(
            child: Center(
              child: BlocBuilder<CustomizeCodingExperienceBloc,
                  CustomizeCodingExperienceState>(
                buildWhen: (prev, next) =>
                    next.tabSize != prev.tabSize ||
                    next.language != prev.language,
                builder: (context, state) {
                  return CustomizableKeyboard(
                    codeController: CodeController(
                      text: state.language.sampleCode,
                      language: state.language.mode,
                      params: EditorParams(
                        tabSpaces: state.tabSize,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    final AppConfigService configService = getIt.get(
      param1: CodingConfigurationValidator(),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt.get<CustomizeCodingExperienceBloc>()
            ..add(
              CustomizeCodingExperienceLoadConfiguration(),
            ),
        ),
        BlocProvider(
          create: (context) => CodeConfigurationImporterCubit(
            configService,
          ),
        ),
        BlocProvider(
          create: (context) => CodeConfigurationExporterCubit(
            configService,
          ),
        ),
      ],
      child: this,
    );
  }

  SpeedDialChild buildSpeedDialChild({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return SpeedDialChild(
      child: Icon(icon),
      label: label,
      elevation: 10,
      labelShadow: [
        BoxShadow(
          color: Theme.of(context).primaryColorDark.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(4, 8), // Shadow position
        ),
      ],
      backgroundColor: Theme.of(context).cardColor,
      labelBackgroundColor: Theme.of(context).cardColor,
      foregroundColor: iconColor,
      shape: const CircleBorder(),
      onTap: onTap,
    );
  }

  void _onCustomizeTheme(BuildContext context) {
    final codeExpBloc = context.read<CustomizeCodingExperienceBloc>();
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      builder: (context) => BlocBuilder<CustomizeCodingExperienceBloc,
          CustomizeCodingExperienceState>(
        bloc: codeExpBloc,
        builder: (context, state) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.65,
            maxChildSize: 0.65,
            builder: (context, controller) => CodeEditorThemePickerBottomsheet(
              scrollController: controller,
              onThemeSelected: (selectedThemeId) {
                codeExpBloc.add(
                  CustomizeCodingExperienceOnThemeChanged(
                    selectedThemeId.id,
                  ),
                );
              },
              currentThemeId: codeExpBloc.state.editorThemeId ??
                  AppCodeEditorTheme.defaultThemeId,
              isDarkBackgroundEnabled: codeExpBloc.state.darkEditorBackground,
              onDarkBackgroundToggle: () {
                codeExpBloc.add(
                  CustomizeCodingExperienceOnDarkEditorBackgroundToggle(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void showEditorPreferences(
    BuildContext context, {
    required void Function({
      bool? hideKeyboard,
      int? tabSize,
      bool? showSuggestions,
      int? fontSize,
      ProgrammingLanguage? language,
    }) onPreferenceChanged,
    required bool initialHideKeyboard,
    required int initialTabSize,
    required bool initialShowSuggestions,
    required int fontSize,
    required ProgrammingLanguage language,
  }) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      builder: (context) => PreferencesBottomSheet(
        onPreferenceChanged: onPreferenceChanged,
        hideKeyboard: initialHideKeyboard,
        tabSize: initialTabSize,
        showSuggestions: initialShowSuggestions,
        fontSize: fontSize,
        language: language,
      ),
    );
  }
}

class CustomizableKeyboard extends StatefulWidget {
  final CodeController codeController;

  const CustomizableKeyboard({
    super.key,
    required this.codeController,
  });

  @override
  State<CustomizableKeyboard> createState() => _CustomizableKeyboardState();
}

class _CustomizableKeyboardState extends State<CustomizableKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocConsumer<CustomizeCodingExperienceBloc,
              CustomizeCodingExperienceState>(
            listenWhen: (prev, cur) =>
                prev.showSuggestions != cur.showSuggestions,
            listener: (context, state) {
              widget.codeController.popupController.enabled =
                  state.showSuggestions;
            },
            buildWhen: (previous, current) =>
                previous.isCustomizing != current.isCustomizing ||
                previous.hideKeyboard != current.hideKeyboard ||
                previous.darkEditorBackground != current.darkEditorBackground ||
                previous.editorThemeId != current.editorThemeId ||
                previous.fontSize != current.fontSize,
            builder: (context, state) {
              return AppCodeEditorField(
                codeController: widget.codeController,
                enabled: !state.isCustomizing,
                editorThemeId: state.editorThemeId,
                pickBackgroundFromTheme: !state.darkEditorBackground,
                keyboardType: (state.hideKeyboard) ? TextInputType.none : null,
                fontSize: state.fontSize.toDouble(),
              );
            },
          ),
        ),
        BlocBuilder<CustomizeCodingExperienceBloc,
            CustomizeCodingExperienceState>(
          buildWhen: (prev, next) => prev.hideKeyboard != next.hideKeyboard,
          builder: (context, state) {
            if (state.hideKeyboard) {
              return const SizedBox.shrink();
            }
            return CustomizableCodingKeys(
              codeController: widget.codeController,
            );
          },
        ),
      ],
    );
  }
}
