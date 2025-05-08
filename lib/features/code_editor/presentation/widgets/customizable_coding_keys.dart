import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/customize_coding_experience/customize_coding_experience_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/coding_key_replacement_dialog.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/coding_keys.dart';
import 'package:codersgym/features/common/widgets/app_animated_text_widget.dart';
import 'package:codersgym/features/common/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:vibration/vibration.dart';

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
                SliverGridDelegateWithFixedCrossAxisCount(
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
                  AppSnackbar.showSuccess(
                    context: context,
                    message: 'Configuration saved successfully',
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
                      icon: Icon(
                        state.isCustomizing
                            ? Icons.remove_red_eye_rounded
                            : Icons.edit,
                      ),
                      label: Text(state.isCustomizing ? "Preview" : "Modify"),
                      onPressed: () {
                        context.read<CustomizeCodingExperienceBloc>().add(
                              CustomizeCodingExperienceOnKeysModifyPreviewModeToggle(),
                            );
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastEaseInToSlowEaseOut,
            child: _buildReorderableWrap(),
          ),
          // ],
          // ),
        ],
      ),
    );
  }
}
