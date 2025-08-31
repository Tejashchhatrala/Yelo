import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:YELO/src/core/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildPage(
            title: 'Welcome to YELO!',
            description: 'Enjoy Local Opportunities.',
            imagePath: 'assets/images/onboarding1.png',
          ),
          _buildPage(
            title: 'Discover & Post',
            description:
                'Find exciting opportunities around you, or post your own!',
            imagePath: 'assets/images/onboarding2.png',
          ),
          _buildPage(
            title: 'Privacy Matters',
            description:
                'We respect your privacy. Your location is only used to show you relevant opportunities.',
            imagePath: 'assets/images/onboarding3.png',
            isLastPage: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required String imagePath,
    bool isLastPage = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 300),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          if (isLastPage)
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('onboarding_completed', true);
                context.router.replaceAll([const SplashRoute()]);
              },
              child: const Text('Get Started'),
            ),
        ],
      ),
    );
  }
}
