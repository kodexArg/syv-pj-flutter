import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syv_ui/syv_ui.dart';

import 'package:syv_pj_flutter/features/showcase/showcase_view.dart';

void main() {
  testWidgets('showcase renders the logo wordmark and all 8 components',
      (tester) async {
    // Tall viewport so the lazy ListView builds the whole specimen at once.
    tester.view.physicalSize = const Size(1200, 8000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: syvTheme(), home: const ShowcaseView()),
    );
    await tester.pump();

    // Logo wordmark.
    expect(find.text('SUBORDINACIÓN y VALOR'), findsWidgets);

    // At least one instance of each of the 8 components.
    expect(find.byType(SyvLogo), findsWidgets);
    expect(find.byType(SyvButton), findsWidgets);
    expect(find.byType(SyvChip), findsWidgets);
    expect(find.byType(SyvCard), findsWidgets);
    expect(find.byType(SyvInput), findsWidgets);
    expect(find.byType(SyvKicker), findsWidgets);
    expect(find.byType(SyvSwitch), findsWidgets);
    expect(find.byType(SyvStat), findsWidgets);
  });
}
