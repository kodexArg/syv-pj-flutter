import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:syv_pj_flutter/app/app.dart';

/// End-to-end smoke test: boots the full app on a real device/emulator and
/// verifies the shell paints its first frame. Run with:
///   flutter test integration_test
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots and shows the home screen', (tester) async {
    await tester.pumpWidget(const SyvPjApp());
    await tester.pumpAndSettle();

    expect(
        find.text('SUBORDINACIÓN y VALOR', skipOffstage: false), findsWidgets);
  });
}
