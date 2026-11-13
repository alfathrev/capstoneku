// ============================================================
// camera_screens.dart — HALAMAN BERGAYA KAMERA (versi demo)
// Pindai Hewan, Ambil Foto, Pindai kulit & bulu. Kamera asli belum dipakai;
// tombol rana hanya berpindah halaman / menampilkan pesan demo.
// ============================================================

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/art.dart';
import 'health_screen.dart';
import 'pet_form_screens.dart';

class _FlashButton extends StatelessWidget {
  const _FlashButton({required this.on, required this.onTap});

  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        on ? Icons.flash_on : Icons.flash_off,
        color: AppTheme.purpleDark,
        size: 22,
      ),
    );
  }
}

/// Add Pet → "Pindai Foto" tab.
class ScanPetScreen extends StatefulWidget {
  const ScanPetScreen({super.key});

  @override
  State<ScanPetScreen> createState() => _ScanPetScreenState();
}

class _ScanPetScreenState extends State<ScanPetScreen> {
  bool _flash = false;

  void _capture() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ReviewScanScreen()));
  }

  void _manual() {
    // NAVIGASI: ganti halaman ini dengan halaman baru (tidak bisa kembali ke sini).
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AddPetScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Pindai Hewan',
      closeIcon: true,
      trailing: _FlashButton(
        on: _flash,
        // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
        onTap: () => setState(() => _flash = !_flash),
      ),
      children: [
        const CameraMock(height: 340, chip: 'Pindai foto'),
        // jarak vertikal 14
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'Posisikan hewanmu di dalam bingkai',
            style: TextStyle(
              color: AppTheme.ink,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        // jarak vertikal 4
        const SizedBox(height: 4),
        const Text(
          'Gunakan cahaya yang cukup. Ambil wajah dan tubuh untuk menyarankan jenis dan ras hewan.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.muted, fontSize: 11, height: 1.4),
        ),
        // jarak vertikal 18
        const SizedBox(height: 18),
        CaptureControls(
          leftIcon: Icons.photo_library_outlined,
          leftLabel: 'Galeri',
          onLeft: _capture,
          rightIcon: _flash ? Icons.flash_on : Icons.flash_off,
          rightLabel: _flash ? 'Flash nyala' : 'Flash mati',
          // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
          onRight: () => setState(() => _flash = !_flash),
          onShutter: _capture,
        ),
        // jarak vertikal 8
        const SizedBox(height: 8),
        // TOMBOL TEKS «Isi detail secara manual» (LinkButton). onPressed = aksi saat ditekan.
        LinkButton(label: 'Isi detail secara manual', onPressed: _manual),
      ],
    );
  }
}

/// Change a pet's profile photo.
class TakePhotoScreen extends StatelessWidget {
  const TakePhotoScreen({super.key, required this.petName});

  final String petName;

  void _done(BuildContext context) {
    // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
    showAppMessage(context, 'Foto baru untuk $petName tersimpan (demo).');
    // NAVIGASI: kembali / tutup halaman atau sheet ini.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Ambil Foto',
      closeIcon: true,
      trailing: const Icon(
        Icons.flash_off,
        color: AppTheme.purpleDark,
        size: 22,
      ),
      children: [
        CameraMock(height: 360, grid: true, label: petName),
        // jarak vertikal 12
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'FOTO',
            style: TextStyle(
              color: AppTheme.purpleDark,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        // jarak vertikal 14
        const SizedBox(height: 14),
        CaptureControls(
          leftIcon: Icons.photo_library_outlined,
          leftLabel: 'Galeri',
          onLeft: () => _done(context),
          rightIcon: Icons.cameraswitch_outlined,
          rightLabel: 'Putar',
          // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
          onRight: () => showAppMessage(context, 'Kamera diputar (demo).'),
          onShutter: () => _done(context),
        ),
        // jarak vertikal 14
        const SizedBox(height: 14),
        Center(
          child: Text(
            'Foto baru untuk profil $petName.',
            style: const TextStyle(color: AppTheme.muted, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

/// Pet Health → Visible-condition scan.
class SkinScanScreen extends StatefulWidget {
  const SkinScanScreen({super.key, required this.petId});

  final String petId;

  @override
  State<SkinScanScreen> createState() => _SkinScanScreenState();
}

class _SkinScanScreenState extends State<SkinScanScreen> {
  bool _flash = false;

  void _capture() {
    // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SkinReviewScreen(petId: widget.petId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final pet = AppScope.of(context).petById(widget.petId);
    final name = pet?.name ?? 'hewanmu';
    return AppPage(
      title: 'Pindai kulit & bulu',
      closeIcon: true,
      children: [
        WhiteCard(
          color: AppTheme.lilac,
          shadow: false,
          // jarak dalam (padding) 10 di semua sisi
          padding: const EdgeInsets.all(10),
          child: const Row(
            children: [
              Icon(
                Icons.verified_outlined,
                size: 18,
                color: AppTheme.purpleDark,
              ),
              // jarak horizontal 8
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pindai kondisi terlihat · hanya penyaringan. Hanya menilai tanda yang tampak, bukan diagnosis.',
                  style: TextStyle(
                    color: AppTheme.purpleDark,
                    fontSize: 10,
                    // tinggi 1.35 px
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        CameraMock(height: 300, chip: 'Pindai luar · $name'),
        // jarak vertikal 14
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'Arahkan ke area yang bermasalah',
            style: TextStyle(
              color: AppTheme.ink,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        // jarak vertikal 4
        const SizedBox(height: 4),
        const Text(
          'Gunakan cahaya yang cukup. Pastikan area terlihat jelas dan jangan disentuh atau ditekan.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.muted, fontSize: 11, height: 1.4),
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        CaptureControls(
          leftIcon: Icons.photo_library_outlined,
          leftLabel: 'Galeri',
          onLeft: _capture,
          rightIcon: _flash ? Icons.flash_on : Icons.flash_off,
          rightLabel: _flash ? 'Flash nyala' : 'Flash mati',
          // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
          onRight: () => setState(() => _flash = !_flash),
          onShutter: _capture,
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Penyaringan kesehatan, bukan pemindai ras',
            style: TextStyle(color: AppTheme.muted, fontSize: 10),
          ),
        ),
      ],
    );
  }
}
