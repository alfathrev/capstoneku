// ============================================================
// health_screen.dart — KESEHATAN HEWAN
// Hub kesehatan, Perawatan Darurat, dan Tinjau pindai kulit.
// ============================================================

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/art.dart';
import 'care_screens.dart';
import 'camera_screens.dart';
import 'pet_form_screens.dart';
import 'symptom_chat_screen.dart';

/// Hub Kesehatan Hewan: cek gejala, pindai, perawatan terdekat, darurat.
class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  String? _petId;

  void _push(Widget page) {
    // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  /// Runs [action] with the selected pet, or asks to add one first.
  void _withPet(Pet? pet, void Function(Pet pet) action) {
    if (pet == null) {
      // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
      showAppMessage(
        context,
        'Tambahkan hewan dulu untuk memakai Kesehatan Hewan.',
      );
      _push(const AddPetScreen());
      return;
    }
    action(pet);
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final pet =
        state.petById(_petId) ?? (state.pets.isEmpty ? null : state.pets.first);

    return AppPage(
      title: 'Kesehatan Hewan',
      subtitle: 'Sedikit bantuan untuk kesehatan hewanmu.',
      children: [
        WhiteCard(
          // jarak dalam (padding): kiri-kanan: 12, atas-bawah: 10
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          onTap: () async {
            if (state.pets.length < 2) return;
            // BOTTOM SHEET: panel yang naik dari bawah layar.
            final picked = await showModalBottomSheet<String>(
              context: context,
              backgroundColor: Colors.white,
              showDragHandle: true,
              // SAFEAREA: menjaga konten tidak tertutup poni/status bar/navigation bar.
              builder: (sheetContext) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final p in state.pets)
                      ListTile(
                        leading: PetAvatar(type: p.type, size: 38),
                        title: Text(p.name),
                        subtitle: Text(p.summary),
                        // NAVIGASI: kembali / tutup halaman atau sheet ini.
                        onTap: () => Navigator.pop(sheetContext, p.id),
                      ),
                  ],
                ),
              ),
            );
            // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
            if (picked != null) setState(() => _petId = picked);
          },
          child: Row(
            children: [
              PetAvatar(type: pet?.type ?? 'Kucing', size: 40),
              // jarak horizontal 10
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet?.name ?? 'Belum ada hewan',
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      pet?.summary ?? 'Tambahkan hewan untuk memulai',
                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: AppTheme.muted),
            ],
          ),
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        Container(
          // jarak dalam (padding) 14 di semua sisi
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.lilac,
            // sudut membulat radius 18
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hewanku sakit',
                style: TextStyle(
                  color: AppTheme.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // jarak vertikal 4
              const SizedBox(height: 4),
              const Text(
                'Bingung harus berbuat apa? Dapatkan sedikit bantuan untuk memahami apa yang mungkin terjadi.',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 11,
                  // tinggi 1.35 px
                  height: 1.35,
                ),
              ),
              // jarak vertikal 12
              const SizedBox(height: 12),
              // TOMBOL «Mulai cek gejala» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              AppButton(
                label: 'Mulai cek gejala',
                // tinggi 40 px
                height: 40,
                fontSize: 12,
                onPressed: () =>
                    _withPet(pet, (p) => _push(SymptomChatScreen(petId: p.id))),
              ),
            ],
          ),
        ),
        // jarak vertikal 10
        const SizedBox(height: 10),
        _HealthOption(
          icon: Icons.chat_bubble_outline,
          title: 'Chat gejala',
          subtitle: 'Kuesioner singkat terpandu',
          onTap: () =>
              _withPet(pet, (p) => _push(SymptomChatScreen(petId: p.id))),
        ),
        // jarak vertikal 8
        const SizedBox(height: 8),
        _HealthOption(
          icon: Icons.document_scanner_outlined,
          title: 'Pindai kondisi terlihat',
          subtitle: 'Cek kulit, bulu & tubuh bagian luar',
          onTap: () => _withPet(pet, (p) => _push(SkinScanScreen(petId: p.id))),
        ),
        // jarak vertikal 8
        const SizedBox(height: 8),
        _HealthOption(
          icon: Icons.location_on_outlined,
          title: 'Perawatan Terdekat',
          subtitle: 'Cari klinik hewan atau petshop',
          onTap: () => _push(const NearbyCareScreen()),
        ),
        // jarak vertikal 14
        const SizedBox(height: 14),
        Container(
          // jarak dalam (padding) 14 di semua sisi
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.roseSoft,
            // sudut membulat radius 16
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded, color: AppTheme.rose, size: 20),
              // jarak horizontal 10
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sesak napas, pingsan, atau pendarahan? Segera cari bantuan dokter hewan.',
                  style: TextStyle(
                    color: Color(0xFF95364F),
                    fontSize: 11,
                    // tinggi 1.4 px
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 4
        const SizedBox(height: 4),
        // TOMBOL TEKS «Cari perawatan darurat →» (LinkButton). onPressed = aksi saat ditekan.
        LinkButton(
          label: 'Cari perawatan darurat →',
          color: AppTheme.rose,
          onPressed: () => _push(UrgentCareScreen(petId: pet?.id)),
        ),
      ],
    );
  }
}

class _HealthOption extends StatelessWidget {
  const _HealthOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      // jarak dalam (padding): kiri-kanan: 12, atas-bawah: 12
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            // lebar 36 px
            width: 36,
            // tinggi 36 px
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.lilac,
              // sudut membulat radius 12
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 19, color: AppTheme.purple),
          ),
          // jarak horizontal 12
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                // jarak vertikal 2
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 10),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.muted, size: 20),
        ],
      ),
    );
  }
}

/// Halaman Perawatan Darurat dengan tombol telepon dan rute.
class UrgentCareScreen extends StatelessWidget {
  const UrgentCareScreen({super.key, this.petId});

  final String? petId;

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final pet = state.petById(petId);
    final provider = kEmergencyProvider;

    return AppPage(
      title: 'Perawatan Darurat',
      subtitle: '${pet?.name ?? 'Hewanmu'} · Penyaringan & lokasi demo',
      children: [
        Container(
          // jarak dalam (padding) 16 di semua sisi
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.roseSoft,
            // sudut membulat radius 18
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppTheme.rose, size: 32),
              // jarak vertikal 8
              SizedBox(height: 8),
              Text(
                'Segera cari perawatan dokter hewan darurat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFB54566),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // jarak vertikal 6
              SizedBox(height: 6),
              Text(
                'Sulit bernapas, pingsan, kejang, atau pendarahan hebat bisa menjadi keadaan darurat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF95536A),
                  fontSize: 11,
                  // tinggi 1.4 px
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 10
        const SizedBox(height: 10),
        const Text(
          'Jangan menunggu hasil pindai, chat, atau booking biasa. Segera temui dokter hewan.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.rose,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            // tinggi 1.4 px
            height: 1.4,
          ),
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        const SectionHeading(title: 'Dokter hewan darurat contoh terdekat'),
        // jarak vertikal 8
        const SizedBox(height: 8),
        WhiteCard(
          // jarak dalam (padding) 14 di semua sisi
          padding: const EdgeInsets.all(14),
          child: Column(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Pill(
                    label: 'Buka 24 jam',
                    bg: Color(0xFFD8F4EE),
                    fg: AppTheme.tealDark,
                  ),
                  // jarak horizontal 8
                  SizedBox(width: 8),
                  Pill(label: 'Demo'),
                ],
              ),
              // jarak vertikal 10
              const SizedBox(height: 10),
              Text(
                provider.name,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // jarak vertikal 3
              const SizedBox(height: 3),
              Text(
                '${provider.distance} · ${provider.address}',
                style: const TextStyle(color: AppTheme.muted, fontSize: 11),
              ),
              // jarak vertikal 6
              const SizedBox(height: 6),
              const Text(
                '✓ Tim dokter hewan darurat',
                style: TextStyle(
                  color: AppTheme.purpleDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // jarak vertikal 14
              const SizedBox(height: 14),
              // TOMBOL «Hubungi dokter hewan darurat» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              AppButton(
                label: 'Hubungi dokter hewan darurat',
                kind: AppButtonKind.danger,
                icon: Icons.phone,
                // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
                onPressed: () => showAppMessage(
                  context,
                  'Hanya demo — tidak ada panggilan yang dilakukan.',
                ),
              ),
              // jarak vertikal 8
              const SizedBox(height: 8),
              // TOMBOL «Rute darurat» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              AppButton(
                label: 'Rute darurat',
                kind: AppButtonKind.soft,
                // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => RouteScreen(provider: provider),
                  ),
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 14
        const SizedBox(height: 14),
        const Text(
          'Telepon dulu jika aman, sambil mengatur transportasi. Ikuti arahan mereka.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.muted, fontSize: 10, height: 1.4),
        ),
      ],
    );
  }
}

/// Hasil pindai kulit (contoh ilustrasi, bukan diagnosis).
class SkinReviewScreen extends StatelessWidget {
  const SkinReviewScreen({super.key, required this.petId});

  final String petId;

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final pet = state.petById(petId);
    const reason =
        'Iritasi kulit terlihat dan bulu rontok (dari pindai kulit).';

    return AppPage(
      title: 'Tinjau pindai kulit',
      children: [
        ClipRRect(
          // sudut membulat radius 20
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            // tinggi 170 px
            height: 170,
            // STACK: menumpuk widget (yang di bawah daftar = lapisan paling atas).
            child: Stack(
              fit: StackFit.expand,
              children: [
                const TealBlobs(),
                const Center(child: CatPortrait(size: 130, body: false)),
                // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
                Positioned(
                  right: 10,
                  bottom: 10,
                  // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
                  child: GestureDetector(
                    // NAVIGASI: kembali / tutup halaman atau sheet ini.
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.purpleDark.withValues(alpha: 0.85),
                        // sudut membulat radius 20
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, size: 14, color: Colors.white),
                          // jarak horizontal 5
                          SizedBox(width: 5),
                          Text(
                            'Ulangi foto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // jarak vertikal 14
        const SizedBox(height: 14),
        WhiteCard(
          child: Column(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengamatan ilustratif',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // jarak vertikal 6
              const SizedBox(height: 6),
              const Text(
                'Contoh kemerahan dan bulu rontok. Ini hanya ilustrasi, bukan foto medis.',
                style: TextStyle(
                  color: AppTheme.ink,
                  fontSize: 12,
                  // tinggi 1.4 px
                  height: 1.4,
                ),
              ),
              // jarak vertikal 10
              const SizedBox(height: 10),
              const Text(
                'Kemungkinan iritasi kulit',
                style: TextStyle(
                  color: AppTheme.purpleDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 10
        const SizedBox(height: 10),
        WhiteCard(
          color: AppTheme.lilac,
          shadow: false,
          // jarak dalam (padding) 12 di semua sisi
          padding: const EdgeInsets.all(12),
          child: const Row(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 16, color: AppTheme.purpleDark),
              // jarak horizontal 8
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ingat: hanya dokter hewan yang bisa mendiagnosis. Dokter hewan harus memastikan penyebabnya.',
                  style: TextStyle(
                    color: AppTheme.purpleDark,
                    fontSize: 11,
                    // tinggi 1.4 px
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 10
        const SizedBox(height: 10),
        Text(
          'Jadwalkan pemeriksaan dokter hewan${pet == null ? '' : ' untuk ${pet.name}'}. Hindari produk kulit baru dan obat manusia.',
          style: const TextStyle(
            color: AppTheme.ink,
            fontSize: 12,
            // tinggi 1.4 px
            height: 1.4,
          ),
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        const SectionHeading(title: 'Dokter hewan terdekat yang disarankan'),
        // jarak vertikal 8
        const SizedBox(height: 8),
        ProviderCard(provider: kProviders.first, reason: reason),
        // jarak vertikal 4
        const SizedBox(height: 4),
        // TOMBOL TEKS «Gejala memburuk? Cari perawatan darurat →» (LinkButton). onPressed = aksi saat ditekan.
        LinkButton(
          label: 'Gejala memburuk? Cari perawatan darurat →',
          color: AppTheme.rose,
          // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => UrgentCareScreen(petId: petId),
            ),
          ),
        ),
      ],
    );
  }
}
