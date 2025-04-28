import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/theme/app_code_editor_theme.dart';
import 'package:codersgym/core/utils/string_extension.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/customize_coding_experience/customize_coding_experience_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/code_editor_theme_picker_bottomsheet.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/coding_key_replacement_dialog.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/coding_keys.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/save_configuration_dialog.dart';
import 'package:codersgym/features/common/widgets/app_animated_text_widget.dart';
import 'package:codersgym/features/common/widgets/app_code_editor_field.dart';
import 'package:codersgym/injection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:reorderables/reorderables.dart';
import 'package:vibration/vibration.dart';

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
      ),
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: const Text(
                'Coding Experience Settings',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.palette),
                title: const Text("Themes"),
                onTap: () {
                  Navigator.pop(context);

                  showModalBottomSheet(
                    context: context,
                    barrierColor: Colors.black.withValues(alpha: 0.2),
                    isScrollControlled: true,
                    showDragHandle: true,
                    enableDrag: true,
                    builder: (context) => BlocBuilder<
                        CustomizeCodingExperienceBloc,
                        CustomizeCodingExperienceState>(
                      bloc: codeExpBloc,
                      builder: (context, state) {
                        return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.65,
                          maxChildSize: 0.65,
                          builder: (context, controller) =>
                              CodeEditorThemePickerBottomsheet(
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
                            isDarkBackgroundEnabled:
                                codeExpBloc.state.darkEditorBackground,
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
                //   showModalBottomSheet(
                //     context: context,
                //     isScrollControlled: true,
                //     builder: (BuildContext context) {
                //       return DraggableScrollableSheet(
                //         initialChildSize: 0.9,
                //         minChildSize: 0.5,
                //         maxChildSize: 0.95,
                //         builder: (_, controller) => Container(
                //           decoration: BoxDecoration(
                //             color: Theme.of(context).cardColor,
                //             borderRadius: const BorderRadius.vertical(
                //                 top: Radius.circular(20)),
                //           ),
                //           child: Column(
                //             children: [
                //               Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text('Select Theme',
                //                     style:
                //                         Theme.of(context).textTheme.titleLarge),
                //               ),
                //               Expanded(
                //                 child: GridView.builder(
                //                   shrinkWrap: true,
                //                   controller: controller,
                //                   padding: const EdgeInsets.all(10),
                //                   gridDelegate:
                //                       const SliverGridDelegateWithFixedCrossAxisCount(
                //                     crossAxisCount: 3,
                //                     childAspectRatio: 1.5,
                //                     crossAxisSpacing: 10,
                //                     mainAxisSpacing: 10,
                //                   ),
                //                   itemCount: themeMap.length,
                //                   itemBuilder: (context, index) {
                //                     final themeName =
                //                         themeMap.keys.elementAt(index);
                //                     return GestureDetector(
                //                       onTap: () {
                //                         // codeExpBloc.add(ThemeChangedEvent(themeName));
                //                         Navigator.pop(context);
                //                       },
                //                       child: Container(
                //                         decoration: BoxDecoration(
                //                           color: Colors.transparent,
                //                           borderRadius: BorderRadius.circular(10),
                //                           border: Border.all(
                //                             color: Theme.of(context)
                //                                 .primaryColor
                //                                 .withOpacity(0.5),
                //                           ),
                //                         ),
                //                         child: Center(
                //                           child: Text(
                //                             themeName,
                //                             textAlign: TextAlign.center,
                //                             style: Theme.of(context)
                //                                 .textTheme
                //                                 .bodyMedium,
                //                           ),
                //                         ),
                //                       ),
                //                     );
                //                   },
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   );
                // },
                ),
            ListTile(
              leading: const Icon(Icons.import_export),
              title: const Text("Export Configuration"),
              onTap: () {
                // Implement export logic
                Navigator.pop(context);
                // Show export dialog or perform export action
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text("Import Configuration"),
              onTap: () {
                // Implement import logic
                Navigator.pop(context);
                // Show import dialog or perform import action
              },
            ),
          ],
        ),
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

class CustomizableCodingKeys extends StatefulWidget {
  const CustomizableCodingKeys({super.key, required this.codeController});
  final CodeController codeController;

  @override
  State<CustomizableCodingKeys> createState() => _CustomizableCodingKeysState();
}

class _CustomizableCodingKeysState extends State<CustomizableCodingKeys> {
  Widget _buildBasicKeyButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        foregroundColor: Colors.white,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: child,
    );
  }

  Widget _buildKeyButton(
      ({CodingKeyConfig key, String keyId}) keyPair, int index) {
    final key = keyPair.key;
    final codingExpBloc = context.read<CustomizeCodingExperienceBloc>();
    return Container(
      width: double.maxFinite,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).indicatorColor.withValues(alpha: 0.05),
      ),
      key: ValueKey(keyPair.keyId),
      child: _buildBasicKeyButton(
        onPressed: () async {
          // show dialog where there is dialog which allow user to select coding key to replace current key
          final replacedKey = await CodingKeyReplacementDialog.show(
            context,
            key.id,
            CodingKeyConfig.defaultCodingKeyConfiguration,
          );
          if (replacedKey != null) {
            codingExpBloc.add(
              CustomizeCodingExperienceOnReplaceKeyConfig(
                keyIndex: index,
                replaceKeyId: replacedKey,
              ),
            );
          }
        },
        child: switch (key) {
          CodingTextKeyConfig() => Text(
              key.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          CodingIconKeyConfig() => Icon(key.icon),
        },
      ),
    );
    ;
  }

  Widget _buildReorderableWrap() {
    // Used for adding separator between keys rows
    // const secondRowStartIndex = 6;
    // const secondRowEndIndex = 13;
    return BlocBuilder<CustomizeCodingExperienceBloc,
        CustomizeCodingExperienceState>(
      buildWhen: (previous, current) =>
          previous.isReordering != current.isReordering ||
          previous.isCustomizing != current.isCustomizing ||
          previous.configurationLoaded != current.configurationLoaded ||
          previous.keyConfiguration != current.keyConfiguration,
      builder: (context, codingExpState) {
        if (!codingExpState.configurationLoaded) {
          return const SizedBox.shrink();
        }
        if (!codingExpState.isCustomizing) {
          return CodingKeys(
            codeController: widget.codeController,
            codingKeyIds: codingExpState.keyConfiguration
                .map(
                  (e) => e.key.id,
                )
                .toList(),
          );
        }

        return Container(
          height: 240,
          child: AnimatedReorderableGridView(
            items: codingExpState.keyConfiguration,
            itemBuilder: (BuildContext context, int index) {
              final keyPair = codingExpState.keyConfiguration[index];
              final key = _buildKeyButton(keyPair, index);

              // if (index > secondRowStartIndex &&
              //     index <= secondRowEndIndex &&
              //     !codingExpState.isReordering) {
              //   return Container(
              //     key: ValueKey(keyPair),
              //     decoration: BoxDecoration(
              //       border: Border(
              //         bottom: BorderSide(
              //           color: Theme.of(context).hintColor,
              //         ),
              //       ),
              //     ),
              //     child: key,
              //   );
              // }
              return Container(
                key: ValueKey(keyPair),
                child: key,
              );
            },

            sliverGridDelegate:
                SliverReorderableGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),

            // Animation configurations
            enterTransition: [
              FlipInX(),
              ScaleIn(),
            ],
            exitTransition: [
              SlideInLeft(),
            ],
            insertDuration: const Duration(milliseconds: 300),
            removeDuration: const Duration(milliseconds: 300),

            onReorder: (oldIndex, newIndex) {
              context.read<CustomizeCodingExperienceBloc>().add(
                    CustomizeCodingExperienceKeySwap(
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    ),
                  );
            },

            dragStartDelay: const Duration(milliseconds: 300),
            isSameItem: (a, b) => a == b,
            onReorderStart: (p0) {
              _vibrateKey();
              context.read<CustomizeCodingExperienceBloc>().add(
                    CustomizeCodingExperienceOnReorrderingStart(),
                  );
            },

            // dragFeedbackBuilder: (context, child) {
            //   return Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(4),
            //       border: Border.all(
            //         color: Theme.of(context).primaryColor.withOpacity(0.5),
            //         width: 2,
            //       ),
            //       color: Theme.of(context).primaryColor.withOpacity(0.1),
            //     ),
            //     child: child,
            //   );
            // },
          ),
        );
      },
    );
  }

  Future<void> _vibrateKey() async {
    // Check if the device can vibrate
    if (await Vibration.hasVibrator() ?? false) {
      // Android-style haptic feedback pattern
      Vibration.vibrate(duration: 50, amplitude: 128);
    } else {
      // Fallback to system haptic feedback
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor.withOpacity(0.4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocConsumer<CustomizeCodingExperienceBloc,
                CustomizeCodingExperienceState>(
              listenWhen: (previous, current) =>
                  previous.modificationStatus != current.modificationStatus,
              listener: (context, state) {
                if (state.modificationStatus ==
                    ConfigurationModificationStatus.saved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configuration saved successfully'),
                    ),
                  );
                }
              },
              buildWhen: (previous, current) =>
                  previous.isCustomizing != current.isCustomizing,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state.isCustomizing)
                      AppAnimatedTextWidget(
                        texts: const [
                          "Hold keys to rearrange",
                          "Tap to replace keys",
                        ],
                        textStyle:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        animationType: AnimatedTextType.typer,
                        repeatCount: 2,
                        speed: const Duration(milliseconds: 80),
                        repeatForever: false,
                      )
                    else
                      Text(
                        "Current Coding Keys Layout",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    TextButton.icon(
                      icon:
                          Icon(state.isCustomizing ? Icons.check : Icons.edit),
                      label: Text(state.isCustomizing ? "Save" : "Edit"),
                      onPressed: () {
                        context.read<CustomizeCodingExperienceBloc>().add(
                              CustomizeCodingExperienceOnKeysEditSaveModeToggle(),
                            );
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.elasticInOut,
            child: _buildReorderableWrap(),
          ),
          // ],
          // ),
        ],
      ),
    );
  }
}
