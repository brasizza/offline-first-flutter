import 'package:flutter/material.dart';

extension AppSnackBar on ScaffoldMessengerState {
  /// Substitui o snackbar atual por uma mensagem com ícone.
  void showMessage(String message, {required IconData icon, SnackBarAction? action}) {
    this
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          action: action,
          // Com ação o SnackBar persistiria até ser fechado; aqui ele some sozinho.
          persist: false,
          duration: const Duration(seconds: 4),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
