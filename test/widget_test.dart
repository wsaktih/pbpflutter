import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_flutter/main.dart';

void main() {
  testWidgets('Portfolio app smoke test', (WidgetTester tester) async {
    // Set desktop screen size for web layout test
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    // Verify that title/gateway elements render
    expect(find.text('Visitor Access Pass'), findsOneWidget);
    expect(find.text('Wishang'), findsOneWidget);
    expect(find.text('NIM (Nomor Induk Mahasiswa)'), findsOneWidget);
    expect(find.text('Password / Kata Sandi'), findsOneWidget);
  });
}
