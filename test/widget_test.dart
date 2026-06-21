import 'package:flutter_test/flutter_test.dart';

import 'package:syv_pj_flutter/app/app.dart';

void main() {
  testWidgets('home view renders greeting and close button', (tester) async {
    await tester.pumpWidget(const SyvPjApp());

    expect(find.text('Hola, mundo!'), findsOneWidget);
    expect(find.text('Cerrar'), findsOneWidget);
  });
}
