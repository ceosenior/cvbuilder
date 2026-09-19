import 'package:flutter/material.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';

abstract final class AppRouter {
  static const onboarding = '/';
  static const home = '/home';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) =>
          settings.name == home ? const HomePage() : const OnboardingPage(),
    );
  }
}
