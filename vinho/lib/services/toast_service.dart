import 'package:flutter/material.dart';
import 'package:vinho/theme/toast_theme.dart';
import 'package:vinho/widgets/toast.dart';

class ToastService {
  static OverlayEntry? _currentToast;

  static void _show(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
  Color textColor = Colors.white,
  IconData? icon,
}) {
  _currentToast?.remove();

  final overlay = Overlay.of(context);

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => ToastWidget(
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
      textColor: textColor,
      onClose: () {
        overlayEntry.remove();
        if (_currentToast == overlayEntry) {
          _currentToast = null;
        }
      },
    ),
  );

  _currentToast = overlayEntry;
  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 10), () {
    if (_currentToast == overlayEntry) {
      overlayEntry.remove();
      _currentToast = null;
    }
  });
}

  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: ToastTheme.successBg,
      textColor: ToastTheme.successText,
      icon: Icons.check_circle,
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: ToastTheme.errorBg,
      textColor: ToastTheme.errorText,
      icon: Icons.error,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: ToastTheme.infoBg,
      textColor: ToastTheme.infoText,
      icon: Icons.info,
    );
  }
}