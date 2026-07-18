import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:https_pinning_poc/main.dart';

void main() {
  testWidgets('La app muestra el toggle de pinning y el botón de consulta',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PinningApp());

    expect(find.text('Certificate Pinning'), findsOneWidget);
    expect(find.text('Consultar API'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
  });
}
