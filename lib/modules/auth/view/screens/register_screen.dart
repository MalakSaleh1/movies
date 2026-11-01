
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../layout/view/main_layout.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/custom_text_field.dart';


class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final PageController _avatarController = PageController(
    viewportFraction: 0.4,
    initialPage: 1,
  );
  int _avatarIndex = 1;

  final List<String> _avatars = const [
    "assets/characters/gamer (1).png",
    "assets/characters/gamer (1)-1.png",
    "assets/characters/gamer (1)-2.png",
    "assets/characters/gamer (1)-3.png",
    "assets/characters/gamer (1)-4.png",
    "assets/characters/gamer (1)-5.png",
    "assets/characters/gamer (1)-6.png",
    "assets/characters/gamer (1)-7.png",
    "assets/characters/gamer (1)-8.png",

  ];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    phoneController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_key.currentState!.validate()) return;

    final auth = context.read<AppAuthProvider>();
    final name = nameController.text.trim();
    final ok = await auth.createAccount(
      email: emailController.text.trim(),
      password: passwordController.text,
      name: name,
      avatar: _avatars[_avatarIndex],
    );
    if (!mounted) return;

    if (ok) {
      AppSnackBar.success(context, "Welcome $name");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainLayout()),
      );
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
        title: Text(
          "Register",
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
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _avatarController,
                    itemCount: _avatars.length,
                    onPageChanged: (i) => setState(() => _avatarIndex = i),
                    itemBuilder: (_, i) => AnimatedScale(
                      scale: i == _avatarIndex ? 1 : 0.6,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: () => _avatarController.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        ),
                        child: ClipOval(
                          child: Image.asset(_avatars[i], fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                 Text(
                  "Avatar",
                  style: TextStyle(color: AppColors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Name",
                  icon: Icons.badge_outlined,
                  controller: nameController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? "Name is required"
                      : null,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                  controller: passwordController,
                  validator: (v) => (v == null || v.length < 6)
                      ? "Password must be at least 6 characters"
                      : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Confirm Password",
                  icon: Icons.lock,
                  isPassword: true,
                  controller: rePasswordController,
                  validator: (v) => v != passwordController.text
                      ? "Passwords don't match"
                      : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Phone Number",
                  icon: Icons.phone,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.trim().length < 10)
                      ? "Enter a valid phone number"
                      : null,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _register,
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
                        :  Text(
                      "Create Account",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      "Already Have Account ? ",
                      style: TextStyle(color: AppColors.white, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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