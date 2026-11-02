
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors/app_colors.dart';

import '../../providers/auth_provider.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/custom_text_field.dart';


class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = "reset_password";
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (!_key.currentState!.validate()) return;

    final auth = context.read<AppAuthProvider>();
    final ok = await auth.resetPassword(email: emailController.text.trim());
    if (!mounted) return;

    if (ok) {
      AppSnackBar.success(context, "Check Your Email");
      Navigator.pop(context);
    } else {
      AppSnackBar.error(context, auth.errorMessageText ?? 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppAuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme:  IconThemeData(color: AppColors.orange),
        title:  Text(
          "Forget Password",
          style: TextStyle(color: AppColors.orange, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _key,
            child: Column(
              children: [
                const SizedBox(height: 32),
                Image.asset(
                  "assets/auth/Forgot password-bro 1.png",
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  hint: "Email",
                  icon: Icons.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      disabledBackgroundColor:
                      AppColors.orange.withOpacity(0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: provider.isLoading
                        ?  SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.black,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Text(
                      "Verify Email",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}