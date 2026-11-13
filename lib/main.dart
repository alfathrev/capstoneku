// ============================================================
// main.dart — TITIK MASUK APLIKASI
// - main() menjalankan PetCareApp.
// - AppScope membungkus MaterialApp agar data (pet, sesi, profil) bisa
//   dipakai semua halaman lewat AppScope.of(context).
// - PhoneFrame membuat tampilan seukuran ponsel Android saat dibuka di web.
// - Sebelum login tampil AuthFlow, sesudah login tampil HomeScreen.
// ============================================================

import 'package:flutter/material.dart';

import 'data/app_state.dart';
import 'screens/auth_flow.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/phone_frame.dart';

void main() {
  runApp(const PetCareApp());
}

/// Widget akar aplikasi: menyimpan AppState dan status login.
class PetCareApp extends StatefulWidget {
  const PetCareApp({super.key});

  @override
  State<PetCareApp> createState() => _PetCareAppState();
}

class _PetCareAppState extends State<PetCareApp> {
  final AppState _state = AppState();
  bool _isAuthenticated = false;

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  void _onAuthComplete(String name) {
    if (name.isNotEmpty) {
      _state.profile.fullName = name;
      final handle = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
      if (handle.isNotEmpty) _state.profile.username = handle;
    }
    // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
    setState(() => _isAuthenticated = true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'BulKu',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        builder: (context, child) =>
            PhoneFrame(child: child ?? const SizedBox()),
        home: _isAuthenticated
            ? const HomeScreen()
            : AuthFlow(onComplete: _onAuthComplete),
      ),
    );
  }
}
