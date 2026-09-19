import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class CvBuildApp extends StatelessWidget {
  const CvBuildApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CV Build',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    initialRoute: AppRouter.onboarding,
    onGenerateRoute: AppRouter.onGenerateRoute,
  );
}
