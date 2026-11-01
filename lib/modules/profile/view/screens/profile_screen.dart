import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/confirm_sheet.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../auth/view/screens/login_screen.dart';
import '../../../library/providers/library_provider.dart';
import '../../../library/view/screens/history_screen.dart';
import '../../../library/view/screens/watch_list_screen.dart';
import '../../data/app_avatars.dart';
import '../../providers/profile_provider.dart';
import '../widgets/profile_action_buttons.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tab_bar.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _exit(BuildContext context) async {
    final confirmed = await showConfirmSheet(
      context,
      icon: Icons.logout,
      title: 'Log out',
      message: 'Are you sure you want to log out?',
      confirmLabel: 'Log out',
    );
    if (!confirmed || !context.mounted) return;

    try {
      await context.read<AppAuthProvider>().signOut();
    } catch (e) {
      debugPrint('signOut failed: $e');
    }
    if (!context.mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginScreen.routeName,
      (route) => false,
    );
  }

  void _edit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UpdateProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;
    final profile = context.watch<ProfileProvider>().profile;
    final library = context.watch<LibraryProvider>();

    final savedName = profile?.name ?? '';
    final name = savedName.isNotEmpty
        ? savedName
        : ((authUser?.displayName?.isNotEmpty ?? false)
            ? authUser!.displayName!
            : 'User');

    final savedAvatar = profile?.avatar ?? '';
    final avatar = savedAvatar.isNotEmpty ? savedAvatar : AppAvatars.all.first;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppColors.darkGrey,
            child: Column(
              children: [
                const SizedBox(height: 28),
                ProfileHeader(
                  name: name,
                  avatar: avatar,
                  wishlistCount: library.wishlist.length,
                  historyCount: library.history.length,
                ),
                const SizedBox(height: 16),
                ProfileActionButtons(
                  onEdit: () => _edit(context),
                  onExit: () => _exit(context),
                ),
                const SizedBox(height: 8),
                const ProfileTabBar(),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                WatchListScreen(),
                HistoryScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
