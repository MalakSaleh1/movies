import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../auth/view/screens/login_screen.dart';
import '../../../library/providers/library_provider.dart';
import '../../data/app_avatars.dart';
import '../../data/models/user_profile.dart';
import '../../providers/profile_provider.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/delete_account_sheet.dart';
import '../widgets/profile_info_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late String _avatar;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AppAuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    _nameController = TextEditingController(text: auth.user?.displayName ?? '');
    _phoneController = TextEditingController();
    _avatar = AppAvatars.all.first;

    _fill(profileProvider.profile);
    if (profileProvider.profile == null) {
      profileProvider.load().then((_) {
        if (mounted) setState(() => _fill(profileProvider.profile));
      });
    }
  }

  void _fill(UserProfile? p) {
    if (p == null) return;
    if (p.name.isNotEmpty) _nameController.text = p.name;
    _phoneController.text = p.phone;
    if (p.avatar.isNotEmpty) _avatar = p.avatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AvatarPickerSheet(selected: _avatar),
    );
    if (picked != null) setState(() => _avatar = picked);
  }

  Future<void> _updateData() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppSnackBar.error(context, 'Please enter your name');
      return;
    }

    final profileProvider = context.read<ProfileProvider>();
    final ok = await profileProvider.update(
      name: name,
      avatar: _avatar,
      phone: _phoneController.text.trim(),
    );
    if (!mounted) return;

    if (ok) {
      context.read<AppAuthProvider>().updateUser();
      AppSnackBar.success(context, 'Profile updated successfully');
      Navigator.pop(context);
    } else {
      AppSnackBar.error(
        context,
        'Failed to update profile: ${profileProvider.error ?? ''}',
      );
    }
  }

  Future<void> _resetPassword() async {
    final email = context.read<AppAuthProvider>().user?.email;
    if (email == null) return;

    final auth = context.read<AppAuthProvider>();
    final ok = await auth.resetPassword(email: email);
    if (!mounted) return;

    if (ok) {
      AppSnackBar.success(context, 'Check Your Email');
    } else {
      AppSnackBar.error(context, auth.errorMessageText ?? 'Something went wrong');
    }
  }

  Future<void> _deleteAccount() async {
    final auth = context.read<AppAuthProvider>();

    final password = await DeleteAccountSheet.show(
      context,
      needsPassword: auth.isPasswordUser,
    );
    if (password == null || !mounted) return; // Cancel

    final ok = await auth.deleteAccount(password: password);
    if (!mounted) return;

    if (!ok) {
      AppSnackBar.error(context, auth.errorMessageText ?? 'Something went wrong');
      return;
    }

    context.read<LibraryProvider>().clear();
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginScreen.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProfileProvider>().isSaving;
    final isDeleting = context.watch<AppAuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.orange),
        title: Text(
          'Pick Avatar',
          style: TextStyle(color: AppColors.orange, fontSize: 14),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: UserAvatar(path: _avatar, size: 150),
                  ),
                  const SizedBox(height: 24),
                  ProfileInfoField(
                    icon: Icons.person,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 14),
                  ProfileInfoField(
                    icon: Icons.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _resetPassword,
                      child: Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 16, color: AppColors.white),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Delete Account',
                    color: AppColors.red,
                    textColor: AppColors.white,
                    onPressed: _deleteAccount,
                    isLoading: isDeleting,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Update Data',
                    color: AppColors.orange,
                    textColor: AppColors.black,
                    onPressed: _updateData,
                    isLoading: isSaving,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
