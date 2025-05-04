import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

enum SnackbarType {
  success,
  error,
  info,
  warning,
}

enum SnackbarPosition {
  top,
  bottom,
}

class AppSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    String? title,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    SnackbarPosition position = SnackbarPosition.top,
  }) {
    final theme = Theme.of(context);

    // Define colors and icons based on snackbar type
    IconData icon;
    Color borderColor;
    Color backgroundColor = theme.colorScheme.surface;
    Color textColor = theme.colorScheme.onSurface;

    switch (type) {
      case SnackbarType.success:
        icon = Icons.check_circle_outline;
        borderColor = theme.colorScheme.primary;
        title ??= 'Success';
        break;
      case SnackbarType.error:
        icon = Icons.error_outline;
        borderColor = theme.colorScheme.error;
        title ??= 'Error';
        break;
      case SnackbarType.warning:
        icon = Icons.warning_amber_outlined;
        borderColor = theme.colorScheme.secondary;
        title ??= 'Warning';
        break;
      case SnackbarType.info:
      default:
        icon = Icons.info_outline;
        borderColor = theme.colorScheme.tertiary;
        title ??= 'Information';
        break;
    }

    // Create and show Flushbar
    Flushbar(
      title: title,
      message: message,
      icon: Icon(
        icon,
        color: borderColor,
        size: 28,
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: 2,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      flushbarPosition: position == SnackbarPosition.top
          ? FlushbarPosition.TOP
          : FlushbarPosition.BOTTOM,
      titleColor: theme.colorScheme.onSurface,
      messageColor: textColor,
      onTap: (_) {
        if (onTap != null) {
          onTap();
        }
      },
      isDismissible: true,
      mainButton: onTap != null
          ? TextButton(
              onPressed: onTap,
              child: Text(
                'Action',
                style: TextStyle(color: borderColor),
              ),
            )
          : null,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(0, 2),
          blurRadius: 3.0,
        )
      ],
    ).show(context);
  }

  // Convenience methods for different types of snackbars
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    SnackbarPosition position = SnackbarPosition.bottom,
  }) {
    show(
      context: context,
      message: message,
      title: title,
      type: SnackbarType.success,
      duration: duration,
      onTap: onTap,
      position: position,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
    SnackbarPosition position = SnackbarPosition.bottom,
  }) {
    show(
      context: context,
      message: message,
      title: title,
      type: SnackbarType.error,
      duration: duration,
      onTap: onTap,
      position: position,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    SnackbarPosition position = SnackbarPosition.bottom,
  }) {
    show(
      context: context,
      message: message,
      title: title,
      type: SnackbarType.info,
      duration: duration,
      onTap: onTap,
      position: position,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    SnackbarPosition position = SnackbarPosition.bottom,
  }) {
    show(
      context: context,
      message: message,
      title: title,
      type: SnackbarType.warning,
      duration: duration,
      onTap: onTap,
      position: position,
    );
  }
}
