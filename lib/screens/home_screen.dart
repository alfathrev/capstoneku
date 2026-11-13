// ============================================================
// home_screen.dart — BERANDA
// Isi dari atas ke bawah: sapaan + avatar, kartu hewan + "Tambah Hewan",
// kartu "Hewanmu kurang sehat?", Acara, Riwayat Sesi.
// ============================================================

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/art.dart';
import 'care_screens.dart';
import 'health_screen.dart';
import 'pet_detail_screen.dart';
import 'pet_form_screens.dart';
import 'profile_screen.dart';
import 'session_screen.dart';

/// Beranda aplikasi setelah login.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final booking = state.booking;
    final sessions = state.sessionsSorted();

    // SCAFFOLD = kerangka satu halaman (background, body, dll.).
    return Scaffold(
      backgroundColor: AppTheme.canvas,
      // SAFEAREA: menjaga konten tidak tertutup poni/status bar/navigation bar.
      body: SafeArea(
        // LISTVIEW: daftar yang bisa di-scroll; padding = jarak di sekeliling isi.
        child: ListView(
          // jarak dalam (padding): kiri 18, atas 18, kanan 18, bawah 28
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat datang kembali,',
                        style: TextStyle(color: AppTheme.muted, fontSize: 13),
                      ),
                      // jarak vertikal 2
                      const SizedBox(height: 2),
                      Text(
                        state.profile.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.ink,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
                GestureDetector(
                  // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(),
                    ),
                  ),
                  child: ProfileAvatar(
                    initial: state.profile.initial,
                    hasPhoto: state.profile.hasPhoto,
                    size: 46,
                  ),
                ),
              ],
            ),
            // jarak vertikal 16
            const SizedBox(height: 16),
            SizedBox(
              // tinggi 92 px
              height: 92,
              // LISTVIEW: daftar yang bisa di-scroll; padding = jarak di sekeliling isi.
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final pet in state.pets) ...[
                    _PetCard(pet: pet),
                    // jarak horizontal 10
                    const SizedBox(width: 10),
                  ],
                  _AddPetCard(
                    // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AddPetScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // jarak vertikal 14
            const SizedBox(height: 14),
            Container(
              // jarak dalam (padding): kiri 14, atas 14, kanan 14, bawah 14
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: AppTheme.lilac,
                // sudut membulat radius 18
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.monitor_heart_outlined,
                        size: 20,
                        color: AppTheme.purple,
                      ),
                      // jarak horizontal 8
                      SizedBox(width: 8),
                      Text(
                        'Hewanmu kurang sehat?',
                        style: TextStyle(
                          color: AppTheme.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  // jarak vertikal 4
                  const SizedBox(height: 4),
                  const Text(
                    'Perawatan kecil dimulai dari sini.',
                    style: TextStyle(color: AppTheme.muted, fontSize: 11),
                  ),
                  // jarak vertikal 10
                  const SizedBox(height: 10),
                  // TOMBOL «Jelajahi Kesehatan Hewan» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
                  AppButton(
                    label: 'Jelajahi Kesehatan Hewan',
                    // tinggi 38 px
                    height: 38,
                    fontSize: 12,
                    // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const HealthScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // jarak vertikal 20
            const SizedBox(height: 20),
            const SectionHeading(title: 'Acara'),
            // jarak vertikal 6
            const SizedBox(height: 6),
            _EventCard(booking: booking, state: state),
            // jarak vertikal 20
            const SizedBox(height: 20),
            SectionHeading(
              title: 'Riwayat Sesi',
              actionLabel: 'Buat',
              onAction: () {
                if (state.pets.isEmpty) {
                  // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
                  showAppMessage(
                    context,
                    'Tambahkan hewan dulu untuk membuat sesi.',
                  );
                  return;
                }
                // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CreateSessionScreen(),
                  ),
                );
              },
            ),
            // jarak vertikal 4
            const SizedBox(height: 4),
            if (sessions.isEmpty)
              // PADDING: memberi ruang kosong di sekeliling child.
              const Padding(
                // jarak dalam (padding): atas-bawah: 18
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  'Belum ada sesi. Ketuk Buat untuk menambahkan.',
                  style: TextStyle(color: AppTheme.muted, fontSize: 12),
                ),
              ),
            for (final session in sessions)
              _SessionRow(session: session, state: state),
          ],
        ),
      ),
    );
  }
}

/// Kartu satu hewan di beranda (avatar, nama, usia, tombol Detail).
class _PetCard extends StatelessWidget {
  const _PetCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // lebar 200 px
      width: 200,
      child: WhiteCard(
        // jarak dalam (padding) 10 di semua sisi
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            PetAvatar(type: pet.type, size: 62),
            // jarak horizontal 10
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                // rata tengah searah susunan (Row: kiri-kanan, Column: atas-bawah)
                mainAxisAlignment: MainAxisAlignment.center,
                // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    pet.ageLabel,
                    style: const TextStyle(color: AppTheme.muted, fontSize: 10),
                  ),
                  // jarak vertikal 6
                  const SizedBox(height: 6),
                  // TOMBOL «Detail» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
                  AppButton(
                    label: 'Detail',
                    // tinggi 26 px
                    height: 26,
                    fontSize: 11,
                    // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PetDetailScreen(petId: pet.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu garis putus-putus "Tambah Hewan".
class _AddPetCard extends StatelessWidget {
  const _AddPetCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        // lebar 92 px
        width: 92,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // sudut membulat radius 18
            borderRadius: BorderRadius.circular(18),
          ),
          child: DashedRRect(
            child: const Column(
              // rata tengah searah susunan (Row: kiri-kanan, Column: atas-bawah)
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppTheme.purple,
                  size: 26,
                ),
                // jarak vertikal 4
                SizedBox(height: 4),
                Text(
                  'Tambah Hewan',
                  style: TextStyle(
                    color: AppTheme.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Kartu acara (banner + judul + tombol Rute).
class _EventCard extends StatelessWidget {
  const _EventCard({required this.booking, required this.state});

  final Booking? booking;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final title = b == null
        ? 'Grooming'
        : 'Kunjungan dokter · ${b.provider.shortName}';
    final when = b == null
        ? 'Hari ini 20:15'
        : '${weekdayDate(b.date)} · ${b.time}';
    final provider = b?.provider ?? kProviders.first;

    return WhiteCard(
      // tanpa padding
      padding: EdgeInsets.zero,
      radius: 20,
      child: ClipRRect(
        // sudut membulat radius 20
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            const _EventBanner(),
            // PADDING: memberi ruang kosong di sekeliling child.
            Padding(
              // jarak dalam (padding): kiri 14, atas 10, kanan 12, bawah 12
              padding: const EdgeInsets.fromLTRB(14, 10, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // jarak vertikal 2
                        const SizedBox(height: 2),
                        Text(
                          when,
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TOMBOL «Rute» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
                  AppButton(
                    label: 'Rute',
                    expand: false,
                    // tinggi 32 px
                    height: 32,
                    fontSize: 12,
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
          ],
        ),
      ),
    );
  }
}

/// Uses assets/images/event_grooming.png if present, otherwise a drawn banner.
class _EventBanner extends StatelessWidget {
  const _EventBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // tinggi 112 px
      height: 112,
      width: double.infinity,
      child: Image.asset(
        'assets/images/event_grooming.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => const _DrawnBanner(),
      ),
    );
  }
}

class _DrawnBanner extends StatelessWidget {
  const _DrawnBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A0C99), Color(0xFF6D24B9), Color(0xFF4A0C99)],
        ),
      ),
      // STACK: menumpuk widget (yang di bawah daftar = lapisan paling atas).
      child: Stack(
        // posisi child: center
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < 8; i++)
            // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
            Positioned(
              left: i.isEven ? i * 40.0 : null,
              right: i.isOdd ? i * 26.0 : null,
              top: i.isEven ? 8 : null,
              bottom: i.isOdd ? 6 : null,
              child: Icon(
                Icons.pets,
                size: 26,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          const Row(
            // item tersebar dengan jarak sama rata
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('🧑🏻', style: TextStyle(fontSize: 46)),
              Text('🐈', style: TextStyle(fontSize: 52)),
              Text('🧑🏽', style: TextStyle(fontSize: 46)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Satu baris riwayat sesi: jam di kiri, kartu di kanan.
class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session, required this.state});

  final HistorySession session;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateLabel = isSameDay(session.date, today)
        ? 'Hari ini'
        : shortDate(session.date);
    final petName = state.petById(session.petId)?.name;
    // PADDING: memberi ruang kosong di sekeliling child.
    return Padding(
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
                    dateLabel,
                    style: const TextStyle(color: AppTheme.muted, fontSize: 9),
                  ),
                  Text(
                    session.time,
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
              // jarak dalam (padding): kiri-kanan: 12, atas-bawah: 10
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              onTap: () => _showDetails(context, petName),
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
                      // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.provider,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Sesi ${session.type}',
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (session.rating != null)
                    Text(
                      session.rating.toString(),
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
    );
  }

  void _showDetails(BuildContext context, String? petName) {
    // BOTTOM SHEET: panel yang naik dari bawah layar.
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      // PADDING: memberi ruang kosong di sekeliling child.
      builder: (_) => Padding(
        // jarak dalam (padding): kiri 24, atas 4, kanan 24, bawah 28
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${session.type} · ${session.provider}',
              style: const TextStyle(
                color: AppTheme.ink,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            // jarak vertikal 6
            const SizedBox(height: 6),
            Text(
              '${petName ?? 'Hewan'} · ${fullShortDate(session.date)} · ${session.time}',
              style: const TextStyle(color: AppTheme.muted, fontSize: 12),
            ),
            if (session.notes.isNotEmpty) ...[
              // jarak vertikal 12
              const SizedBox(height: 12),
              Text(
                session.notes,
                style: const TextStyle(color: AppTheme.ink, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
