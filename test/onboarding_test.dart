import 'package:cvbuild/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cvbuild/core/services/storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTesting();
  });
  testWidgets('Intro advances, finishes, and can be reopened', (tester) async {
    await tester.pumpWidget(const CvBuildApp());
    expect(find.text('Katta imkoniyatlar,\nmukammal CV dan.'), findsOneWidget);
    await tester.tap(find.text('Keyingi'));
    await tester.pumpAndSettle();
    expect(find.text('Siz haqingizda.\nEng yaxshi tarzda.'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Boshlash'), findsOneWidget);
    await tester.tap(find.text('Boshlash'));
    await tester.pumpAndSettle();
    expect(find.text('Mening CV larim'), findsOneWidget);
    await tester.tap(find.text('Tanishtiruvni qayta ko‘rish'));
    await tester.pumpAndSettle();
    expect(find.text('Keyingi'), findsOneWidget);
    await tester.tap(find.text('O‘tkazib yuborish'));
    await tester.pumpAndSettle();
    expect(find.text('Mening CV larim'), findsOneWidget);
  });

  testWidgets('Small screen with large text does not overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const CvBuildApp());
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Keyingi'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
