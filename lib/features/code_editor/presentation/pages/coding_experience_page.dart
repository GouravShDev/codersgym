import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/coding_key_configuration/coding_key_configuration_cubit.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/coding_keys.dart';
import 'package:codersgym/features/common/widgets/app_code_editor_field.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize Experience"),
      ),
      body: SafeArea(
        child: Center(
          child: CustomizableKeyboard(
            codeController: CodeController(
              text: sampleCode,
              language: ProgrammingLanguage.cpp.mode,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt.get<CodingKeyConfigurationCubit>()..loadConfiguration(),
      child: this,
    );
  }
}

class CustomizableKeyboard extends StatefulWidget {
  final CodeController codeController;

  const CustomizableKeyboard({
    Key? key,
    required this.codeController,
  }) : super(key: key);

  @override
  State<CustomizableKeyboard> createState() => _CustomizableKeyboardState();
}

class _CustomizableKeyboardState extends State<CustomizableKeyboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AppCodeEditorField(
            codeController: widget.codeController,
            enabled: false,
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
  State<CustomizableCodingKeys> createState() =>
      _CustomizableCodingKeysState2();
}

// class _CustomizableCodingKeysState extends State<CustomizableCodingKeys>
//     with TickerProviderStateMixin {
//   bool _isCustomizing = false;
//   List<CodingKeyConfig> currentConfiguration = CodingKeyConfig
//       .defaultCodingKeyConfiguration
//       .map((e) => CodingKeyConfig.lookupMap[e]?.call())
//       .whereType<CodingKeyConfig>()
//       .toList();

//   Widget _buildKeyButton(CodingKeyConfig key, {bool isDraggable = false}) {
//     Widget button = _buildBasicKeyButton(
//       onPressed: () {},
//       child: switch (key) {
//         CodingTextKeyConfig() => Text(
//             key.label,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         CodingIconKeyConfig() => Icon(key.icon),
//       },
//     );
//     if (!isDraggable) return button;

//     return LongPressDraggable<CodingKeyConfig>(
//       data: key,
//       feedback: Material(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           // color: Theme.of(context).primaryColor.withOpacity(0.8),
//           child: switch (key) {
//             CodingTextKeyConfig() => Text(
//                 key.label,
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             CodingIconKeyConfig() => Icon(key.icon),
//           },
//         ),
//       ),
//       childWhenDragging: Opacity(opacity: 0.8, child: button),
//       child: DragTarget<CodingKeyConfig>(
//         onAcceptWithDetails: (data) => _handleKeySwap(key, data.data),
//         builder: (context, candidateData, rejectedData) {
//           return button;
//         },
//       ),
//     );
//   }

//   void _handleKeySwap(CodingKeyConfig target, CodingKeyConfig source) {
//     setState(() {
//       final targetIndex = currentConfiguration.indexOf(target);
//       final sourceIndex = currentConfiguration.indexOf(source);

//       if (targetIndex != -1 && sourceIndex != -1) {
//         final temp = currentConfiguration[targetIndex];
//         currentConfiguration[targetIndex] = currentConfiguration[sourceIndex];
//         currentConfiguration[sourceIndex] = temp;
//       }
//     });
//   }

//   Widget _buildBasicKeyButton({
//     required VoidCallback onPressed,
//     required Widget child,
//   }) {
//     return TextButton(
//       onPressed: onPressed,
//       style: TextButton.styleFrom(
//         minimumSize: Size.zero,
//         foregroundColor: Colors.white,
//         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       ),
//       child: child,
//     );
//   }

//   Widget _buildKeysGrid(List<CodingKeyConfig> keys) {
//     if (!_isCustomizing) {
//       return BlocBuilder<CodingKeyConfigurationCubit,
//           CodingKeyConfigurationState>(
//         builder: (context, state) {
//           final configuration = switch (state) {
//             CodingKeyConfigurationLoaded() => state.keysConfiguration,
//             CodingKeyNoUserConfiguration() =>
//               CodingKeyConfig.defaultCodingKeyConfiguration,
//             _ => CodingKeyConfig.defaultCodingKeyConfiguration,
//           };
//           return CodingKeys(
//             codeController: widget.codeController,
//             codingKeyIds: configuration,
//           );
//         },
//       );
//     }
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 7,
//       ),
//       itemCount: keys.length,
//       itemBuilder: (context, index) {
//         final key = _buildKeyButton(keys[index], isDraggable: _isCustomizing);
//         // Create separation border between the keys layout
//         if (index > 6 && index <= 13) {
//           return Container(
//             decoration: BoxDecoration(
//                 border: Border(
//                     bottom: BorderSide(
//               color: Theme.of(context).hintColor,
//             ))),
//             child: key,
//           );
//         }
//         return key;
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).cardColor.withOpacity(0.4),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _isCustomizing
//                       ? "Hold Keys To Rearrange"
//                       : "Current Coding Keys Layout",
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 TextButton.icon(
//                   icon: Icon(_isCustomizing ? Icons.check : Icons.edit),
//                   label: Text(_isCustomizing ? "Save" : "Edit"),
//                   onPressed: () {
//                     setState(() {
//                       _isCustomizing = !_isCustomizing;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),

//           AnimatedSize(
//             duration: Duration(milliseconds: 200),
//             curve: Curves.elasticInOut,
//             child: _buildKeysGrid(
//               currentConfiguration,
//             ),
//           ),
//           // ],
//           // ),
//         ],
//       ),
//     );
//   }
// }

class _CustomizableCodingKeysState2 extends State<CustomizableCodingKeys>
    with TickerProviderStateMixin {
  bool _isCustomizing = false;
  late final List<(CodingKeyConfig, String)> currentConfiguration;
  String? _draggedKeyId;
  String? _targetKeyId;
  late final AnimationController _dropAnimationController;
  final Map<String, Offset> _positions = {};
  final Map<String, GlobalKey> _keyWidgetKeys = {};

  @override
  void initState() {
    super.initState();
    _dropAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    currentConfiguration = CodingKeyConfig.defaultCodingKeyConfiguration
        .map((e) => CodingKeyConfig.lookupMap[e]?.call())
        .whereType<CodingKeyConfig>()
        .map((config) => (config, UniqueKey().toString()))
        .toList();

    // Initialize keys for each item
    for (final config in currentConfiguration) {
      _keyWidgetKeys[config.$2] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _dropAnimationController.dispose();
    super.dispose();
  }

  void _updatePositions() {
    for (final entry in _keyWidgetKeys.entries) {
      final key = entry.value;
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        _positions[entry.key] = position;
      }
    }
  }

  // Calculate the target position for animation
  Offset _calculateTargetPosition(
      int sourceIndex, int targetIndex, double itemWidth, double itemHeight) {
    final sourceRow = sourceIndex ~/ 7;
    final sourceCol = sourceIndex % 7;
    final targetRow = targetIndex ~/ 7;
    final targetCol = targetIndex % 7;

    return Offset(
      (targetCol - sourceCol) * itemWidth,
      (targetRow - sourceRow) * itemHeight,
    );
  }

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

  Widget _buildKeyButton((CodingKeyConfig, String) keyPair, int index,
      {bool isDraggable = false}) {
    final (key, id) = keyPair;
    Widget button = _buildBasicKeyButton(
      onPressed: () {},
      child: switch (key) {
        CodingTextKeyConfig() => Text(
            key.label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        CodingIconKeyConfig() => Icon(key.icon),
      },
    );
    
    if (!isDraggable) return button;

    return LayoutBuilder(
      builder: (context, constraints) {
        return LongPressDraggable<(CodingKeyConfig, String, int)>(
          data: (key, id, index),
          hapticFeedbackOnStart: false, // Disable default feedback
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: switch (key) {
                CodingTextKeyConfig() => Text(
                    key.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                CodingIconKeyConfig() => Icon(
                    key.icon,
                    color: Colors.white,
                  ),
              },
            ),
          ),
          onDragStarted: () async {
            await _vibrateKey();
            _updatePositions();
            setState(() => _draggedKeyId = id);
          },
          onDragEnd: (_) {
            _dropAnimationController.forward(from: 0.0);
            setState(() {
              _draggedKeyId = null;
              _targetKeyId = null;
            });
          },
          childWhenDragging: Opacity(opacity: 0, child: button),
          child: DragTarget<(CodingKeyConfig, String, int)>(
            onWillAccept: (data) {
              if (data == null || data.$2 == id) return false;
              setState(() => _targetKeyId = id);
              return true;
            },
            onLeave: (_) {
              setState(() => _targetKeyId = null);
            },
            onAcceptWithDetails: (details) {
              final sourceIndex = details.data.$3;
              _handleKeySwap(keyPair, (details.data.$1, details.data.$2));
              _dropAnimationController.forward(from: 0.0);
              setState(() => _targetKeyId = null);
            },
            builder: (context, candidateData, rejectedData) {
              final isTarget = _targetKeyId == id;
              final isDragged = _draggedKeyId == id;

              return AnimatedBuilder(
                animation: _dropAnimationController,
                builder: (context, child) {
                  final progress = _dropAnimationController.value;
                  final scale = isDragged ? 0.95 + (0.05 * progress) : 1.0;

                  return Container(
                    key: _keyWidgetKeys[id],
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      transform: Matrix4.identity()..scale(scale),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isTarget
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: button,
                      ),
                    ),
                  );
                },
              );
            },
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


  void _handleKeySwap(
      (CodingKeyConfig, String) target, (CodingKeyConfig, String) source) {
    setState(() {
      final targetIndex =
          currentConfiguration.indexWhere((pair) => pair.$2 == target.$2);
      final sourceIndex =
          currentConfiguration.indexWhere((pair) => pair.$2 == source.$2);

      if (targetIndex != -1 && sourceIndex != -1) {
        // Store old positions
        final oldPositions = Map<String, Offset>.from(_positions);

        // Perform the swap
        final temp = currentConfiguration[targetIndex];
        currentConfiguration[targetIndex] = currentConfiguration[sourceIndex];
        currentConfiguration[sourceIndex] = temp;

        // Schedule a frame to capture new positions after layout
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updatePositions();
          setState(() {});
        });
      }
    });
  }

  Widget _buildKeysGrid(List<(CodingKeyConfig, String)> keys) {
    if (!_isCustomizing) {
      return BlocBuilder<CodingKeyConfigurationCubit,
          CodingKeyConfigurationState>(
        builder: (context, state) {
          final configuration = switch (state) {
            CodingKeyConfigurationLoaded() => state.keysConfiguration,
            CodingKeyNoUserConfiguration() =>
              CodingKeyConfig.defaultCodingKeyConfiguration,
            _ => CodingKeyConfig.defaultCodingKeyConfiguration,
          };
          return CodingKeys(
            codeController: widget.codeController,
            codingKeyIds: configuration,
          );
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final keyPair = keys[index];
        final key =
            _buildKeyButton(keyPair, index, isDraggable: _isCustomizing);

        if (index > 6 && index <= 13) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            child: key,
          );
        }
        return key;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor.withOpacity(0.4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isCustomizing
                      ? "Hold Keys To Rearrange"
                      : "Current Coding Keys Layout",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  icon: Icon(_isCustomizing ? Icons.check : Icons.edit),
                  label: Text(_isCustomizing ? "Save" : "Edit"),
                  onPressed: () {
                    setState(() {
                      _isCustomizing = !_isCustomizing;
                    });
                  },
                ),
              ],
            ),
          ),

          AnimatedSize(
            duration: Duration(milliseconds: 200),
            curve: Curves.elasticInOut,
            child: _buildKeysGrid(
              currentConfiguration,
            ),
          ),
          // ],
          // ),
        ],
      ),
    );
  }
}
