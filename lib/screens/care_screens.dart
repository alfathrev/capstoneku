// ============================================================
// care_screens.dart — PERAWATAN TERDEKAT -> PENYEDIA -> RUTE -> BOOKING
// ProviderCard (kartu penyedia) dipakai di beberapa halaman.
// ============================================================

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/art.dart';

void _openRoute(BuildContext context, CareProvider provider) {
  // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => RouteScreen(provider: provider)),
  );
}

void _openBooking(
  BuildContext context,
  CareProvider provider, {
  String? reason,
}) {
  // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BookVisitScreen(provider: provider, reason: reason),
    ),
  );
}

/// Provider summary card used in nearby care, chat result and skin review.
class ProviderCard extends StatelessWidget {
  const ProviderCard({
    super.key,
    required this.provider,
    this.showHours = false,
    this.tappable = true,
    this.reason,
  });

  final CareProvider provider;
  final bool showHours;
  final bool tappable;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      // jarak dalam (padding) 12 di semua sisi
      padding: const EdgeInsets.all(12),
      onTap: tappable
          // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
          ? () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    CareProviderScreen(provider: provider, reason: reason),
              ),
            )
          : null,
      child: Column(
        // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider.name,
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          // jarak vertikal 3
          const SizedBox(height: 3),
          Text(
            '${provider.distance} · ★ ${provider.rating} · Penyedia demo',
            style: const TextStyle(color: AppTheme.muted, fontSize: 10),
          ),
          if (showHours) ...[
            // jarak vertikal 3
            const SizedBox(height: 3),
            Text(
              provider.hours.startsWith('Buka')
                  ? provider.hours
                  : 'Buka ${provider.hours}',
              style: const TextStyle(
                color: AppTheme.tealDark,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          // jarak vertikal 6
          const SizedBox(height: 6),
          Text(
            provider.emergency
                ? '✓ Tim dokter hewan darurat'
                : '✓ Konsultasi dokter hewan',
            style: const TextStyle(
              color: AppTheme.purpleDark,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          // jarak vertikal 10
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                // TOMBOL «Rute» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
                child: AppButton(
                  label: 'Rute',
                  kind: AppButtonKind.soft,
                  // tinggi 34 px
                  height: 34,
                  fontSize: 11,
                  onPressed: () => _openRoute(context, provider),
                ),
              ),
              // jarak horizontal 8
              const SizedBox(width: 8),
              Expanded(
                // TOMBOL «Pesan kunjungan» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
                child: AppButton(
                  label: 'Pesan kunjungan',
                  // tinggi 34 px
                  height: 34,
                  fontSize: 11,
                  onPressed: () =>
                      _openBooking(context, provider, reason: reason),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Daftar penyedia perawatan terdekat + pencarian.
class NearbyCareScreen extends StatefulWidget {
  const NearbyCareScreen({super.key});

  @override
  State<NearbyCareScreen> createState() => _NearbyCareScreenState();
}

class _NearbyCareScreenState extends State<NearbyCareScreen> {
  String _query = '';
  bool _openNow = false;
  bool _vetAvailable = false;

  @override
  Widget build(BuildContext context) {
    final results = kProviders.where((p) {
      if (_query.isNotEmpty &&
          !p.name.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }
      return true; // all sample providers are open and have vets
    }).toList();

    return AppPage(
      title: 'Perawatan Terdekat',
      subtitle: 'Klinik hewan & petshop dengan layanan dokter hewan',
      children: [
        WhiteCard(
          // jarak dalam (padding): kiri-kanan: 12, atas-bawah: 10
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppTheme.purple,
              ),
              // jarak horizontal 8
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Willow Square',
                  style: TextStyle(
                    color: AppTheme.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Pill(label: 'Lokasi demo'),
            ],
          ),
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        // KOLOM INPUT (TextField): onChanged dipanggil setiap teks berubah.
        TextField(
          // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
          onChanged: (v) => setState(() => _query = v.trim()),
          style: const TextStyle(fontSize: 13, color: AppTheme.ink),
          decoration: fieldDecoration(
            hint: 'Cari perawatan hewan',
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: AppTheme.muted,
            ),
          ),
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        Row(
          children: [
            // CHIP PILIHAN «Buka sekarang». onTap = dipanggil saat dipilih; selected = tampil terpilih.
            ChoiceTag(
              label: 'Buka sekarang',
              icon: Icons.schedule,
              selected: _openNow,
              // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
              onTap: () => setState(() => _openNow = !_openNow),
            ),
            // jarak horizontal 8
            const SizedBox(width: 8),
            // CHIP PILIHAN «Dokter tersedia». onTap = dipanggil saat dipilih; selected = tampil terpilih.
            ChoiceTag(
              label: 'Dokter tersedia',
              icon: Icons.medical_services_outlined,
              selected: _vetAvailable,
              // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
              onTap: () => setState(() => _vetAvailable = !_vetAvailable),
            ),
          ],
        ),
        // jarak vertikal 14
        const SizedBox(height: 14),
        Text(
          '${results.length} penyedia contoh · terdekat lebih dulu',
          style: const TextStyle(color: AppTheme.muted, fontSize: 11),
        ),
        // jarak vertikal 8
        const SizedBox(height: 8),
        if (results.isEmpty)
          // PADDING: memberi ruang kosong di sekeliling child.
          const Padding(
            // jarak dalam (padding): atas-bawah: 30
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'Tidak ada penyedia yang cocok.',
                style: TextStyle(color: AppTheme.muted, fontSize: 12),
              ),
            ),
          ),
        for (final p in results)
          // PADDING: memberi ruang kosong di sekeliling child.
          Padding(
            // jarak dalam (padding): bawah: 10
            padding: const EdgeInsets.only(bottom: 10),
            child: ProviderCard(provider: p, showHours: true),
          ),
      ],
    );
  }
}

/// Detail satu penyedia perawatan.
class CareProviderScreen extends StatelessWidget {
  const CareProviderScreen({super.key, required this.provider, this.reason});

  final CareProvider provider;
  final String? reason;

  Widget _infoRow(IconData icon, String text) {
    // PADDING: memberi ruang kosong di sekeliling child.
    return Padding(
      // jarak dalam (padding): bawah: 10
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.purple),
          // jarak horizontal 10
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppTheme.ink, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Penyedia Perawatan',
      children: [
        WhiteCard(
          // jarak dalam (padding): atas-bawah: 20
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Container(
                // lebar 56 px
                width: 56,
                // tinggi 56 px
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.lilac,
                  // sudut membulat radius 16
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.pets, color: AppTheme.purple, size: 28),
              ),
              // jarak vertikal 10
              const SizedBox(height: 10),
              Text(
                provider.name.split(' ').first.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.purpleDark,
                  fontSize: 18,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                provider.tagline,
                style: const TextStyle(color: AppTheme.muted, fontSize: 11),
              ),
            ],
          ),
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        Row(
          children: [
            const Pill(
              label: 'Dokter tersedia',
              bg: Color(0xFFD8F4EE),
              fg: AppTheme.tealDark,
            ),
            // jarak horizontal 8
            const SizedBox(width: 8),
            const Pill(
              label: 'Buka sekarang',
              bg: Color(0xFFD8F4EE),
              fg: AppTheme.tealDark,
            ),
            // jarak horizontal 8
            const SizedBox(width: 8),
            Text(
              '${provider.distance} dari sini',
              style: const TextStyle(color: AppTheme.muted, fontSize: 10),
            ),
          ],
        ),
        // jarak vertikal 14
        const SizedBox(height: 14),
        WhiteCard(
          child: Column(
            children: [
              _infoRow(Icons.location_on_outlined, provider.address),
              _infoRow(
                Icons.schedule,
                provider.hours.startsWith('Buka')
                    ? provider.hours
                    : 'Setiap hari · ${provider.hours}',
              ),
              _infoRow(
                Icons.star_outline,
                '${provider.rating} · Penyedia demo',
              ),
            ],
          ),
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        const SectionHeading(title: 'Layanan dokter hewan'),
        // jarak vertikal 8
        const SizedBox(height: 8),
        // WRAP: susun ke samping, otomatis pindah baris jika penuh (spacing = jarak antar item).
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in provider.services) Pill(label: s, fontSize: 11),
          ],
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        WhiteCard(
          color: AppTheme.lilac,
          shadow: false,
          child: Row(
            children: [
              const Icon(
                Icons.event_available_outlined,
                color: AppTheme.purpleDark,
              ),
              // jarak horizontal 10
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Janji temu contoh berikutnya',
                      style: TextStyle(color: AppTheme.muted, fontSize: 10),
                    ),
                    // jarak vertikal 2
                    SizedBox(height: 2),
                    Text(
                      'Rab, 4 Nov · 16:00',
                      style: TextStyle(
                        color: AppTheme.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 18
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              // TOMBOL «Rute» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              child: AppButton(
                label: 'Rute',
                kind: AppButtonKind.soft,
                onPressed: () => _openRoute(context, provider),
              ),
            ),
            // jarak horizontal 10
            const SizedBox(width: 10),
            Expanded(
              // TOMBOL «Pesan kunjungan» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              child: AppButton(
                label: 'Pesan kunjungan',
                onPressed: () =>
                    _openBooking(context, provider, reason: reason),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Pratinjau rute (demo) dengan pilihan mobil / jalan kaki.
class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key, required this.provider});

  final CareProvider provider;

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  bool _car = true;

  @override
  Widget build(BuildContext context) {
    final p = widget.provider;
    final minutes = _car ? p.carMinutes : p.walkMinutes;
    return AppPage(
      title: 'Rute',
      subtitle: 'Pratinjau rute demo · Bukan navigasi langsung',
      children: [
        MapMock(height: 270, providerName: p.shortName),
        // jarak vertikal 12
        const SizedBox(height: 12),
        Row(
          children: [
            // CHIP PILIHAN «Mobil · ${p.carMinutes} mnt». onTap = dipanggil saat dipilih; selected = tampil terpilih.
            ChoiceTag(
              label: 'Mobil · ${p.carMinutes} mnt',
              icon: Icons.directions_car_outlined,
              selected: _car,
              // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
              onTap: () => setState(() => _car = true),
            ),
            // jarak horizontal 8
            const SizedBox(width: 8),
            // CHIP PILIHAN «Jalan kaki · ${p.walkMinutes} mnt». onTap = dipanggil saat dipilih; selected = tampil terpilih.
            ChoiceTag(
              label: 'Jalan kaki · ${p.walkMinutes} mnt',
              icon: Icons.directions_walk,
              selected: !_car,
              // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
              onTap: () => setState(() => _car = false),
            ),
          ],
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        WhiteCard(
          child: Column(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.name,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // jarak vertikal 4
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.near_me_outlined,
                    size: 14,
                    color: AppTheme.purple,
                  ),
                  // jarak horizontal 5
                  const SizedBox(width: 5),
                  Text(
                    '${p.distance} · $minutes menit dengan ${_car ? 'mobil' : 'jalan kaki'}',
                    style: const TextStyle(color: AppTheme.muted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        // TOMBOL «Pesan kunjungan» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
        AppButton(
          label: 'Pesan kunjungan',
          onPressed: () => _openBooking(context, p),
        ),
      ],
    );
  }
}

/// Form pesan kunjungan dokter hewan.
class BookVisitScreen extends StatefulWidget {
  const BookVisitScreen({super.key, required this.provider, this.reason});

  final CareProvider provider;
  final String? reason;

  @override
  State<BookVisitScreen> createState() => _BookVisitScreenState();
}

class _BookVisitScreenState extends State<BookVisitScreen> {
  static const _times = ['16:00', '18:00', '20:00'];

  late final TextEditingController _reason;
  late final List<DateTime> _days;
  String? _petId;
  int _dayIndex = 0;
  String _time = _times.first;

  @override
  void initState() {
    super.initState();
    _reason = TextEditingController(text: widget.reason ?? '');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _days = [for (var i = 0; i < 3; i++) today.add(Duration(days: i))];
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final pet =
        state.petById(_petId) ?? (state.pets.isEmpty ? null : state.pets.first);
    final date = _days[_dayIndex];
    final end = Booking(
      provider: widget.provider,
      petId: pet?.id ?? '',
      date: date,
      time: _time,
      reason: '',
    ).endTime;
    final email = state.profile.email.isEmpty
        ? '${state.profile.username}@demo.example.com'
        : state.profile.email;

    return AppPage(
      title: 'Pesan Kunjungan Dokter',
      subtitle: 'Janji temu contoh · Bukan janji sungguhan',
      children: [
        WhiteCard(
          child: Column(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.provider.name,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // jarak vertikal 3
              const SizedBox(height: 3),
              Text(
                widget.provider.address,
                style: const TextStyle(color: AppTheme.muted, fontSize: 11),
              ),
              // jarak vertikal 5
              const SizedBox(height: 5),
              const Text(
                'Konsultasi dokter hewan · 30 menit',
                style: TextStyle(
                  color: AppTheme.purpleDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 14
        const SizedBox(height: 14),
        if (state.pets.isEmpty)
          const Text(
            'Tambahkan hewan dulu agar klinik tahu siapa yang datang.',
            style: TextStyle(color: AppTheme.rose, fontSize: 12),
          )
        else
          // FIELD PILIHAN «Hewan»: diketuk membuka daftar opsi (bottom sheet).
          SelectField(
            label: 'Hewan',
            options: [for (final p in state.pets) p.name],
            value: pet?.name,
            // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
            onChanged: (name) => setState(() {
              _petId = state.pets.firstWhere((p) => p.name == name).id;
            }),
          ),
        if (pet != null)
          // PADDING: memberi ruang kosong di sekeliling child.
          Padding(
            // jarak dalam (padding): atas: 4, kiri: 4
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              '${pet.type} · ${pet.breed} · ${pet.sex}',
              style: const TextStyle(color: AppTheme.muted, fontSize: 10),
            ),
          ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        SectionHeading(title: '${_monthName(date)} ${date.year}'),
        // jarak vertikal 6
        const SizedBox(height: 6),
        // WRAP: susun ke samping, otomatis pindah baris jika penuh (spacing = jarak antar item).
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < _days.length; i++)
              // CHIP PILIHAN.
              ChoiceTag(
                label: weekdayDate(_days[i]),
                selected: _dayIndex == i,
                // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
                onTap: () => setState(() => _dayIndex = i),
              ),
          ],
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        Text(
          'Jam tersedia · ${fullShortDate(date)}',
          style: const TextStyle(
            color: AppTheme.muted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        // jarak vertikal 8
        const SizedBox(height: 8),
        // WRAP: susun ke samping, otomatis pindah baris jika penuh (spacing = jarak antar item).
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in _times)
              // CHIP PILIHAN «Alasan kunjungan». onTap = dipanggil saat dipilih; selected = tampil terpilih.
              ChoiceTag(
                label: t,
                selected: _time == t,
                // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
                onTap: () => setState(() => _time = t),
              ),
          ],
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        // FIELD INPUT «Alasan kunjungan»: controller menyimpan teks, validator = aturan validasi.
        AppTextField(
          label: 'Alasan kunjungan',
          controller: _reason,
          hint: 'Ceritakan apa yang kamu perhatikan',
          maxLines: 2,
        ),
        // jarak vertikal 14
        const SizedBox(height: 14),
        // FIELD PICKER «Kontak · detail demo»: diketuk membuka pemilih (tanggal/jam).
        PickerField(
          label: 'Kontak · detail demo',
          value: '${state.profile.username} · $email',
          onTap: () {},
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        WhiteCard(
          color: AppTheme.lilac,
          shadow: false,
          child: Column(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weekdayDate(date).replaceFirst(' ', ', ')} · $_time–$end',
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // jarak vertikal 3
              const SizedBox(height: 3),
              Text(
                '${pet?.name ?? 'Hewanmu'} · Konsultasi dokter hewan · Bayar di tempat; biaya dikonfirmasi klinik',
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 11,
                  // tinggi 1.35 px
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 18
        const SizedBox(height: 18),
        // TOMBOL «Konfirmasi booking demo» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
        AppButton(
          label: 'Konfirmasi booking demo',
          onPressed: pet == null
              ? null
              : () {
                  state.setBooking(
                    Booking(
                      provider: widget.provider,
                      petId: pet.id,
                      date: date,
                      time: _time,
                      reason: _reason.text.trim().isEmpty
                          ? 'Konsultasi umum.'
                          : _reason.text.trim(),
                    ),
                  );
                  // NAVIGASI: ganti halaman ini dengan halaman baru (tidak bisa kembali ke sini).
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const BookingConfirmationScreen(),
                    ),
                  );
                },
        ),
      ],
    );
  }

  String _monthName(DateTime d) {
    const names = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return names[d.month - 1];
  }
}

/// Konfirmasi booking (demo).
class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final b = state.booking;
    if (b == null) {
      return AppPage(
        title: 'Janji Temu Kamu',
        // NAVIGASI: kembali sampai halaman paling awal (beranda).
        onBack: () => Navigator.of(context).popUntil((r) => r.isFirst),
        children: const [
          // PADDING: memberi ruang kosong di sekeliling child.
          Padding(
            // jarak dalam (padding): atas-bawah: 40
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'Belum ada booking demo.',
                style: TextStyle(color: AppTheme.muted),
              ),
            ),
          ),
        ],
      );
    }
    final pet = state.petById(b.petId);
    final petName = pet?.name ?? 'hewanmu';

    return AppPage(
      title: 'Janji Temu Kamu',
      // NAVIGASI: kembali sampai halaman paling awal (beranda).
      onBack: () => Navigator.of(context).popUntil((r) => r.isFirst),
      children: [
        // jarak vertikal 4
        const SizedBox(height: 4),
        Center(
          child: Container(
            // lebar 64 px
            width: 64,
            // tinggi 64 px
            height: 64,
            decoration: const BoxDecoration(
              color: AppTheme.lilac,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 34,
              color: AppTheme.purple,
            ),
          ),
        ),
        // jarak vertikal 10
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Semua siap untuk $petName!',
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        // jarak vertikal 10
        const SizedBox(height: 10),
        WhiteCard(
          color: AppTheme.lilac,
          shadow: false,
          // jarak dalam (padding) 10 di semua sisi
          padding: const EdgeInsets.all(10),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppTheme.purpleDark),
              // jarak horizontal 8
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hanya konfirmasi demo. Tidak ada janji temu sungguhan yang dibuat.',
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
        // jarak vertikal 14
        const SizedBox(height: 14),
        WhiteCard(
          child: Column(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                b.provider.name,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // jarak vertikal 2
              const SizedBox(height: 2),
              Text(
                b.provider.address,
                style: const TextStyle(color: AppTheme.muted, fontSize: 11),
              ),
              const Divider(height: 22, color: AppTheme.line),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 20,
                    color: AppTheme.purple,
                  ),
                  // jarak horizontal 10
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_longDate(b.date)} ${b.date.year}',
                          style: const TextStyle(
                            color: AppTheme.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${b.time} – ${b.endTime} · Konsultasi dokter hewan',
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
              const Divider(height: 22, color: AppTheme.line),
              Row(
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
                          petName,
                          style: const TextStyle(
                            color: AppTheme.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (pet != null)
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
              // jarak vertikal 10
              const SizedBox(height: 10),
              Text(
                'Alasan: ${b.reason}',
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 11,
                  // tinggi 1.35 px
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 18
        const SizedBox(height: 18),
        // TOMBOL «Rute ke ${b.provider.shortName}» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
        AppButton(
          label: 'Rute ke ${b.provider.shortName}',
          icon: Icons.directions,
          onPressed: () => _openRoute(context, b.provider),
        ),
        // jarak vertikal 10
        const SizedBox(height: 10),
        // TOMBOL «Kelola booking demo» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
        AppButton(
          label: 'Kelola booking demo',
          kind: AppButtonKind.soft,
          onPressed: () => _manage(context, state),
        ),
      ],
    );
  }

  void _manage(BuildContext context, AppState state) {
    // BOTTOM SHEET: panel yang naik dari bawah layar.
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      // SAFEAREA: menjaga konten tidak tertutup poni/status bar/navigation bar.
      builder: (sheetContext) => SafeArea(
        // PADDING: memberi ruang kosong di sekeliling child.
        child: Padding(
          // jarak dalam (padding): kiri 22, atas 0, kanan 22, bawah 16
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TOMBOL «Kembali ke beranda» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              AppButton(
                label: 'Kembali ke beranda',
                onPressed: () {
                  // NAVIGASI: kembali / tutup halaman atau sheet ini.
                  Navigator.pop(sheetContext);
                  // NAVIGASI: kembali sampai halaman paling awal (beranda).
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
              ),
              // jarak vertikal 10
              const SizedBox(height: 10),
              // TOMBOL «Batalkan booking demo» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              AppButton(
                label: 'Batalkan booking demo',
                kind: AppButtonKind.dangerSoft,
                onPressed: () {
                  state.setBooking(null);
                  // NAVIGASI: kembali / tutup halaman atau sheet ini.
                  Navigator.pop(sheetContext);
                  // NAVIGASI: kembali sampai halaman paling awal (beranda).
                  Navigator.of(context).popUntil((r) => r.isFirst);
                  // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
                  showAppMessage(context, 'Booking demo dibatalkan.');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _longDate(DateTime d) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return '${days[d.weekday - 1]}, ${shortDate(d)}';
  }
}
