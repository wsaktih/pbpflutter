import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_flutter/main.dart';
import 'package:tugas_flutter/models/user_model.dart';
import 'package:tugas_flutter/pages/mahasiswa_page.dart';

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

    // Dispose widget tree to cancel periodic timers
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('MahasiswaPage renders student cards with gender avatars', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final testUser = DeveloperGuestUser(
      id: 'usr-001',
      username: 'tester',
      displayName: 'Test User',
      avatarUrl: 'assets/images/profile.jpeg',
    );

    await tester.pumpWidget(MaterialApp(
      home: MahasiswaPage(currentUser: testUser),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify header and initial student cards
    expect(find.text('Katalog Mahasiswa'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Siti Rahayu'), findsOneWidget);
    expect(find.text('Wishang'), findsOneWidget);
    expect(find.text('Dewi Permata'), findsOneWidget);
    expect(find.text('Rizky Pratama'), findsOneWidget);

    // Verify avatar images are rendered
    expect(find.byType(Image), findsWidgets);
  });
}

