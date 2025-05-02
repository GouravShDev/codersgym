import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/theme/app_code_editor_theme.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/customize_coding_experience/customize_coding_experience_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/code_editor_theme_picker_bottomsheet.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/customizable_coding_keys.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/preference_bottomsheet.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/save_configuration_dialog.dart';
import 'package:codersgym/features/common/widgets/app_code_editor_field.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

const String sampleCode = """class Solution {
public:
    bool twoSum(string s, int k) {
        
    }
};""";

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
              return ElevatedButton.icon(
                onPressed: state.modificationStatus ==
                        ConfigurationModificationStatus.unsaved
                    ? () {}
                    : null,
                icon: Icon(Icons.save_rounded),
                label: Text("Save"),
              );
            },
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<CustomizeCodingExperienceBloc,
          CustomizeCodingExperienceState>(
        builder: (context, state) {
          return AnimatedPadding(
            padding: EdgeInsets.only(
              bottom: (state.isCustomizing ? 280 : 120),
            ),
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticInOut,
            child: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              overlayOpacity: 0.4,
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
                    showEditorPreferences(
                      context,
                      onPreferenceChanged: ({
                        bool? hideKeyboard,
                        int? tabSize,
                        bool? showSuggestions,
                        int? fontSize,
                      }) {},
                      initialHideKeyboard: false,
                      initialShowSuggestions: false,
                      initialTabSize: 4,
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
                  },
                ),
                buildSpeedDialChild(
                  context: context,
                  icon: Icons.download,
                  label: 'Import Config',
                  iconColor: Colors.lightBlue,
                  onTap: () {
                    debugPrint('Import Configuration selected');
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: PopScope(
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
            child: CustomizableKeyboard(
              codeController: CodeController(
                text: sampleCode,
                language: ProgrammingLanguage.cpp.mode,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<CustomizeCodingExperienceBloc>()
        ..add(
          CustomizeCodingExperienceLoadConfiguration(),
        ),
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
          offset: Offset(4, 8), // Shadow position
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
    }) onPreferenceChanged,
    bool initialHideKeyboard = false,
    int initialTabSize = 2,
    bool initialShowSuggestions = true,
  }) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => PreferencesBottomSheet(
        onPreferenceChanged: onPreferenceChanged,
        hideKeyboard: initialHideKeyboard,
        tabSize: initialTabSize,
        showSuggestions: initialShowSuggestions,
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
          child: BlocBuilder<CustomizeCodingExperienceBloc,
              CustomizeCodingExperienceState>(
            buildWhen: (previous, current) =>
                previous.isCustomizing != current.isCustomizing ||
                previous.darkEditorBackground != current.darkEditorBackground ||
                previous.editorThemeId != current.editorThemeId,
            builder: (context, state) {
              // return HighlightView(
              //   sampleCode,
              //   language: "cpp",
              //   theme: themeMap[state.editorThemeId]!,
              // );
              return AppCodeEditorField(
                codeController: widget.codeController,
                enabled: !state.isCustomizing,
                editorThemeId: state.editorThemeId,
                pickBackgroundFromTheme: !state.darkEditorBackground,
              );
            },
          ),
        ),
        CustomizableCodingKeys(
          codeController: widget.codeController,
        ),
      ],
    );
  }
}
