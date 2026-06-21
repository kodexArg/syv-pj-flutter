import 'package:flutter_test/flutter_test.dart';

import 'package:syv_pj_flutter/app/app.dart';

void main() {
  testWidgets('home view renders the greeting', (tester) async {
    await tester.pumpWidget(const SyvPjApp());

    expect(find.text('Hola, mundo!'), findsOneWidget);
  });
}
