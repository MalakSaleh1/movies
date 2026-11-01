
import 'package:flutter/material.dart';
import '../../../layout/view/main_layout.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>MainLayout()));
  }

  Future<void> _login() async {
    if (!_key.currentState!.validate()) return;

    final auth = context.read<AppAuthProvider>();
    final ok = await auth.signIn(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    if (!mounted) return;

    if (ok) {
      final name = auth.user?.displayName;
      AppSnackBar.success(
        context,
        (name == null || name.isEmpty) ? "Welcome Back" : "Welcome Back $name",
      );
      _goHome();
    } else {
      AppSnackBar.error(context, auth.errorMessageText ?? 'Something went wrong');
    }
  }

  Future<void> _loginWithGoogle() async {
    final auth = context.read<AppAuthProvider>();
    final ok = await auth.signInWithGoogle();
    if (!mounted) return;

    if (ok) {
      final name = auth.user?.displayName;
      AppSnackBar.success(
        context,
        (name == null || name.isEmpty) ? "Welcome" : "Welcome $name",
      );
      _goHome();
    } else {
      AppSnackBar.error(context, auth.errorMessageText ?? 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppAuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _key,
            child: Column(
              children: [
                const SizedBox(height: 48),
                Image.asset("assets/logo/movies_logo.png", height: 120),
                const SizedBox(height: 48),

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
                const SizedBox(height: 24),
                CustomTextField(
                  hint: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                  controller: passwordController,
                  validator: (v) => (v == null || v.length < 6)
                      ? "Password must be at least 6 characters"
                      : null,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      ResetPasswordScreen.routeName,
                    ),
                    child: Text(
                      "Forget Password ?",
                      style: TextStyle(color: AppColors.orange, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // زرار Login
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _login,
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
                        ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.black,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't Have Account ? ",
                      style: TextStyle(color: AppColors.white, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        RegisterScreen.routeName,
                      ),
                      child: Text(
                        "Create One",
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // OR
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.orange,
                        indent: 48,
                        endIndent: 16,
                      ),
                    ),
                    Text("OR", style: TextStyle(color: AppColors.orange)),
                    Expanded(
                      child: Divider(
                        color: AppColors.orange,
                        indent: 16,
                        endIndent: 48,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // زرار Login With Google
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                    provider.isLoadingForGoogle ? null : _loginWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      disabledBackgroundColor:
                      AppColors.orange.withOpacity(0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: provider.isLoadingForGoogle
                        ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.black,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/logo/icon _google_.png",
                            height: 28),
                        const SizedBox(width: 12),
                        Text(
                          "Login With Google",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 90,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: BoxBorder.all(
                      width: 2,
                      color: AppColors.orange
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/language/LR.png"),
                      Image.asset("assets/language/EG.png",),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}