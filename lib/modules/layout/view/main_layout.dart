import 'package:flutter/material.dart';

import '../../../core/theme/app_colors/app_colors.dart';
import '../../movies/view/screens/browse_screen.dart';
import '../../movies/view/screens/home_screen.dart';
import '../../movies/view/screens/search_screen.dart';
import '../../profile/view/screens/profile_screen.dart';
import 'widgets/floating_nav_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _index = 0;

  final _tabs = const [
    HomeScreen(),
    SearchScreen(),
    BrowseScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      extendBody: true,
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        icons: const [
          Icons.home_rounded,
          Icons.search_rounded,
          Icons.explore_rounded,
          Icons.person_rounded,
        ],
      ),
    );
  }
}
