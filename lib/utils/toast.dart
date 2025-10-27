import 'package:flutter/material.dart';

class ToastMessage {
  static void show(BuildContext context, String message) {
    try {
      // ✅ Ensure context is still active
      if (!context.mounted) return;

      // ✅ Try to get valid ScaffoldMessenger
      final messenger = ScaffoldMessenger.maybeOf(context) ??
          ScaffoldMessenger.of(Navigator.of(context, rootNavigator: true).context);

      final snackBar = SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      );

      messenger.showSnackBar(snackBar);
    } catch (e) {
      // ✅ Never crash, just log silently
      debugPrint('ToastMessage error: $e — message: $message');
    }
  }
}
