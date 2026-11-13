// ============================================================
// pet_detail_screen.dart — DETAIL HEWAN
// Memakai Stack: lapisan bawah = header teal + kucing, lapisan tengah =
// ListView (konten bisa di-scroll), lapisan atas = tombol kembali/menu.
// ============================================================

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/art.dart';
import 'camera_screens.dart';
import 'pet_form_screens.dart';
import 'session_screen.dart';

/// Halaman detail satu hewan (dibuka dari tombol "Detail").
class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key, required this.petId});

  final String petId;

  void _edit(BuildContext context) {
    // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => EditPetScreen(petId: petId)),
    );
  }

  void _photo(BuildContext context, Pet pet) {
    // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TakePhotoScreen(petName: pet.name),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Pet pet) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    // BOTTOM SHEET: panel yang naik dari bawah layar.
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      // SAFEAREA: menjaga konten tidak tertutup poni/status bar/navigation bar.
      builder: (sheetContext) => SafeArea(
        // PADDING: memberi ruang kosong di sekeliling child.
        child: Padding(
          // jarak dalam (padding): kiri 22, atas 4, kanan 22, bawah 16
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WhiteCard(
                color: AppTheme.canvas,
                shadow: false,
                // jarak dalam (padding) 10 di semua sisi
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    PetAvatar(type: pet.type, size: 52),
                    // jarak horizontal 12
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.name,
                            style: const TextStyle(
                              color: AppTheme.ink,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            pet.summary,
                            style: const TextStyle(
                              color: AppTheme.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // jarak vertikal 16
              const SizedBox(height: 16),
              Text(
                'Hapus ${pet.name}?',
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // jarak vertikal 6
              const SizedBox(height: 6),
              Text(
                'Profil ${pet.name} akan dihapus dari daftar hewanmu. Tindakan ini tidak dapat dibatalkan.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 12,
                  // tinggi 1.4 px
                  height: 1.4,
                ),
              ),
              // jarak vertikal 18
              const SizedBox(height: 18),
              // TOMBOL «Batal» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              AppButton(
                label: 'Batal',
                kind: AppButtonKind.soft,
                // NAVIGASI: kembali / tutup halaman atau sheet ini.
                onPressed: () => Navigator.pop(sheetContext),
              ),
              // jarak vertikal 10
              const SizedBox(height: 10),
              // TOMBOL «Hapus Hewan» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              AppButton(
                label: 'Hapus Hewan',
                kind: AppButtonKind.danger,
                onPressed: () {
                  // NAVIGASI: kembali / tutup halaman atau sheet ini.
                  Navigator.pop(sheetContext);
                  // NAVIGASI: kembali / tutup halaman atau sheet ini.
                  Navigator.pop(context);
                  // Remove after the page transition so the screen does not flash.
                  Future<void>.delayed(const Duration(milliseconds: 350), () {
                    state.deletePet(pet.id);
                    messenger
                      ..hideCurrentSnackBar()
                      // SNACKBAR: pesan singkat di bawah layar.
                      ..showSnackBar(
                        SnackBar(
                          content: Text('${pet.name} berhasil dihapus.'),
                        ),
                      );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final pet = state.petById(petId);
    if (pet == null) {
      return const Scaffold(backgroundColor: AppTheme.canvas);
    }
    final sessions = state.sessionsSorted(petId: pet.id);

    // SCAFFOLD = kerangka satu halaman (background, body, dll.).
    return Scaffold(
      backgroundColor: AppTheme.canvas,
      // STACK: menumpuk widget (yang di bawah daftar = lapisan paling atas).
      body: Stack(
        children: [
          // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            // tinggi 330 px
            height: 330,
            child: _Header(),
          ),
          // LISTVIEW: daftar yang bisa di-scroll; padding = jarak di sekeliling isi.
          ListView(
            // tanpa padding
            padding: EdgeInsets.zero,
            children: [
              // jarak vertikal 236
              const SizedBox(height: 236),
              Container(
                width: double.infinity,
                // jarak dalam (padding): kiri 20, atas 18, kanan 20, bawah 18
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      pet.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppTheme.ink,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  // jarak horizontal 8
                                  const SizedBox(width: 8),
                                  // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
                                  GestureDetector(
                                    onTap: () => _edit(context),
                                    child: const Pill(
                                      label: 'Ubah',
                                      icon: Icons.edit_outlined,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              // jarak vertikal 2
                              const SizedBox(height: 2),
                              Text(
                                pet.ageLabel,
                                style: const TextStyle(
                                  color: AppTheme.muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // TOMBOL «Ambil Foto» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
                        AppButton(
                          label: 'Ambil Foto',
                          icon: Icons.photo_camera_outlined,
                          expand: false,
                          // tinggi 38 px
                          height: 38,
                          fontSize: 11,
                          onPressed: () => _photo(context, pet),
                        ),
                      ],
                    ),
                    // jarak vertikal 16
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _Stat(
                          emoji: '🐱',
                          label: 'Jenis kelamin',
                          value: pet.sex,
                        ),
                        _Stat(emoji: '🎨', label: 'Ras', value: pet.breed),
                        _Stat(
                          emoji: '⚖️',
                          label: 'Berat',
                          value: '${formatWeight(pet.weight)} kg',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: AppTheme.canvas,
                // jarak dalam (padding): kiri 18, atas 16, kanan 18, bawah 28
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
                constraints: const BoxConstraints(minHeight: 400),
                child: Column(
                  // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: _SessionStat(
                            title: 'Sesi Makan',
                            value: '3/Jam',
                            dark: false,
                          ),
                        ),
                        // jarak horizontal 12
                        SizedBox(width: 12),
                        Expanded(
                          child: _SessionStat(
                            title: 'Sesi Kesehatan',
                            value: '2/Minggu',
                            dark: true,
                          ),
                        ),
                      ],
                    ),
                    // jarak vertikal 20
                    const SizedBox(height: 20),
                    SectionHeading(
                      title: 'Riwayat Sesi',
                      actionLabel: 'Buat',
                      // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
                      onAction: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CreateSessionScreen(petId: pet.id),
                        ),
                      ),
                    ),
                    if (sessions.isEmpty)
                      // PADDING: memberi ruang kosong di sekeliling child.
                      const Padding(
                        // jarak dalam (padding): atas-bawah: 16
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Belum ada sesi untuk hewan ini.',
                          style: TextStyle(color: AppTheme.muted, fontSize: 12),
                        ),
                      ),
                    for (final s in sessions)
                      // PADDING: memberi ruang kosong di sekeliling child.
                      Padding(
                        // jarak dalam (padding): atas: 10
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              // lebar 46 px
                              width: 46,
                              // PADDING: memberi ruang kosong di sekeliling child.
                              child: Padding(
                                // jarak dalam (padding): atas: 6
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(
                                  // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shortDate(s.date),
                                      style: const TextStyle(
                                        color: AppTheme.muted,
                                        fontSize: 9,
                                      ),
                                    ),
                                    Text(
                                      s.time,
                                      style: const TextStyle(
                                        color: AppTheme.ink,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: WhiteCard(
                                radius: 16,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppTheme.lilac,
                                      child: Icon(
                                        Icons.medical_services_outlined,
                                        size: 18,
                                        color: AppTheme.purple,
                                      ),
                                    ),
                                    // jarak horizontal 10
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.provider,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppTheme.ink,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            'Sesi ${s.type}',
                                            style: const TextStyle(
                                              color: AppTheme.muted,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (s.rating != null)
                                      Text(
                                        s.rating.toString(),
                                        style: const TextStyle(
                                          color: AppTheme.ink,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // SAFEAREA: menjaga konten tidak tertutup poni/status bar/navigation bar.
          SafeArea(
            // PADDING: memberi ruang kosong di sekeliling child.
            child: Padding(
              // jarak dalam (padding): kiri 14, atas 8, kanan 14, bawah 0
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                children: [
                  _RoundIcon(
                    icon: Icons.arrow_back,
                    // NAVIGASI: kembali / tutup halaman atau sheet ini.
                    onTap: () => Navigator.maybePop(context),
                  ),
                  // SPACER: mendorong widget ke sisi berlawanan (mengisi sisa ruang).
                  const Spacer(),
                  // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
                  GestureDetector(
                    onTap: () => _photo(context, pet),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        // sudut membulat radius 20
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                          // jarak horizontal 5
                          SizedBox(width: 5),
                          Text(
                            'Ambil Foto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SPACER: mendorong widget ke sisi berlawanan (mengisi sisa ruang).
                  const Spacer(),
                  // MENU TITIK TIGA (PopupMenuButton): itemBuilder = daftar menu, onSelected = aksi menu yang dipilih.
                  PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                      // sudut membulat radius 14
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: Colors.white,
                    onSelected: (value) {
                      if (value == 'edit') _edit(context);
                      if (value == 'delete') _confirmDelete(context, pet);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: AppTheme.purpleDark,
                            ),
                            // jarak horizontal 10
                            SizedBox(width: 10),
                            Text('Ubah Hewan'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: AppTheme.rose,
                            ),
                            // jarak horizontal 10
                            SizedBox(width: 10),
                            Text(
                              'Hapus Hewan',
                              style: TextStyle(color: AppTheme.rose),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      // lebar 38 px
                      width: 38,
                      // tinggi 38 px
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.more_horiz, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    // STACK: menumpuk widget (yang di bawah daftar = lapisan paling atas).
    return const Stack(
      fit: StackFit.expand,
      children: [
        TealBlobs(),
        Align(alignment: Alignment(0, -0.1), child: CatPortrait(size: 220)),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // lebar 38 px
        width: 38,
        // tinggi 38 px
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.emoji, required this.label, required this.value});

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          // jarak vertikal 3
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: AppTheme.muted, fontSize: 10),
          ),
          // jarak vertikal 1
          const SizedBox(height: 1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionStat extends StatelessWidget {
  const _SessionStat({
    required this.title,
    required this.value,
    required this.dark,
  });

  final String title;
  final String value;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      // jarak dalam (padding): kiri 14, atas 12, kanan 14, bawah 12
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: dark ? AppTheme.purpleDark : AppTheme.purple,
        // sudut membulat radius 18
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                dark ? Icons.favorite_border : Icons.restaurant,
                color: Colors.white,
                size: 18,
              ),
              // jarak horizontal 6
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ),
            ],
          ),
          // jarak vertikal 6
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          // jarak vertikal 6
          const SizedBox(height: 6),
          dark ? const MiniBars() : const WaveLine(),
        ],
      ),
    );
  }
}
