import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/confirm_sheet.dart';

/// تأكيد حذف الحساب. بترجّع الباسورد (String) لو أكّد، أو null لو لغى.
/// لو الحساب جوجول ([needsPassword] = false) بترجّع string فاضي.
class DeleteAccountSheet extends StatefulWidget {
  final bool needsPassword;
  const DeleteAccountSheet({super.key, required this.needsPassword});

  static Future<String?> show(
    BuildContext context, {
    required bool needsPassword,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeleteAccountSheet(needsPassword: needsPassword),
    );
  }

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _confirm() {
    final password = _passwordController.text.trim();
    if (widget.needsPassword && password.isEmpty) return;
    Navigator.pop(context, password);
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmSheet(
      icon: Icons.delete_forever,
      title: 'Delete Account',
      message: widget.needsPassword
          ? 'Enter your password to confirm.\nThis action cannot be undone.'
          : 'Are you sure you want to delete your account?\nThis action cannot be undone.',
      confirmLabel: 'Delete',
      onConfirm: _confirm,
      onCancel: () => Navigator.pop(context),
      extra: widget.needsPassword
          ? TextField(
              controller: _passwordController,
              obscureText: _obscure,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.white54),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white54,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.red),
                ),
              ),
            )
          : null,
    );
  }
}
