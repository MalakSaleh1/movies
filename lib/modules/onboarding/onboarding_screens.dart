// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors/app_colors.dart';
import 'package:movies/modules/auth/view/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Color> _gradientColors = const [
    Color(0xFF601321),
    Color(0xff084250),
    Color(0xFF85210E),
    Color(0xFF4C2471),
    Color(0xFF2A2C30),
  ];

  final List<Map<String, String>> _pages = const [
    {
      "image": "assets/onboarding/onboarding1.png",
      "title": "Discover Movies",
      "description":
      "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
    },
    {
      "image": "assets/onboarding/onboarding2.png",
      "title": "Explore All Genres",
      "description":
      "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
    },
    {
      "image": "assets/onboarding/onboarding3.png",
      "title": "Create Watchlists",
      "description":
      "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
    },
    {
      "image": "assets/onboarding/onboarding4.png",
      "title": "Rate, Review, and Learn",
      "description":
      "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
    },
    {
      "image": "assets/onboarding/onboarding5.png",
      "title": "Start Watching Now",
      "description": "",
    },
  ];

  bool get _isFirst => _currentIndex == 0;
  bool get _isLast => _currentIndex == _pages.length - 1;

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _back() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [

          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, i) => Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  _pages[i]["image"]!,
                  alignment: Alignment.topCenter,
                ),

                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        _gradientColors[i].withOpacity(0.7),
                        _gradientColors[i],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF121312),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SafeArea(
                top: false,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        page["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (page["description"]!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          page["description"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _isLast ? "Finish" : "Next",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      if (!_isFirst) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: _back,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.orange,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Back",
                              style: TextStyle(
                                color: AppColors.orange,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}