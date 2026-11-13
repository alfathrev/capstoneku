import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:persiapan_capstone/main.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('Sign up leads to home with Arthur and Pet Health', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const PetCareApp());

    expect(find.text('BulKu'), findsOneWidget);

    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Buat akun'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Amanda');
    await tester.enterText(find.byType(TextFormField).at(1), 'amanda@test.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');
    await tester.ensureVisible(find.text('Daftar').last);
    await tester.tap(find.text('Daftar').last);
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang kembali,'), findsOneWidget);
    expect(find.text('Arthur'), findsOneWidget);
    expect(find.text('Hewanmu kurang sehat?'), findsOneWidget);

    await tester.tap(find.text('Jelajahi Kesehatan Hewan'));
    await tester.pumpAndSettle();
    expect(find.text('Chat gejala'), findsOneWidget);
  });
}
