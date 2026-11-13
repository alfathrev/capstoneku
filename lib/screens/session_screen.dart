// ============================================================
// session_screen.dart — BUAT RIWAYAT SESI
// Form: hewan, jenis sesi, tanggal, waktu, penyedia, catatan, rating bintang.
// ============================================================

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

const kSessionTypes = [
  'Grooming',
  'Kunjungan dokter',
  'Vaksinasi',
  'Pemeriksaan',
  'Pelatihan',
];

/// Form Buat Sesi untuk menambah Riwayat Sesi.
class CreateSessionScreen extends StatefulWidget {
  const CreateSessionScreen({super.key, this.petId});

  final String? petId;

  @override
  State<CreateSessionScreen> createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _provider = TextEditingController();
  final _notes = TextEditingController();
  String? _petId;
  String? _type = 'Grooming';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _petId = widget.petId;
  }

  @override
  void dispose() {
    _provider.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    // DIALOG PEMILIH TANGGAL bawaan Flutter.
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    // DIALOG PEMILIH JAM bawaan Flutter.
    final picked = await showTimePicker(context: context, initialTime: _time);
    // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
    if (picked != null) setState(() => _time = picked);
  }

  void _save(AppState state) {
    // VALIDASI form: true jika semua validator lolos.
    final ok = _formKey.currentState?.validate() ?? false;
    final pets = state.pets;
    final petId = _petId ?? (pets.length == 1 ? pets.first.id : null);
    if (!ok || petId == null || _type == null) {
      // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
      if (petId == null) showAppMessage(context, 'Pilih hewan untuk sesi ini.');
      return;
    }
    state.addSession(
      HistorySession(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        petId: petId,
        type: _type!,
        date: _date,
        time: formatTime(_time),
        provider: _provider.text.trim(),
        notes: _notes.text.trim(),
        rating: _rating == 0 ? null : _rating,
      ),
    );
    // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
    showAppMessage(context, 'Sesi tersimpan.');
    // NAVIGASI: kembali / tutup halaman atau sheet ini.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final names = state.pets.map((p) => p.name).toList();
    final selected = state.petById(
      _petId ?? (state.pets.length == 1 ? state.pets.first.id : null),
    );

    return AppPage(
      title: 'Buat sesi',
      closeIcon: true,
      subtitle: 'Tambahkan kunjungan ke Riwayat Sesi hewanmu.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FIELD PILIHAN «Hewan»: diketuk membuka daftar opsi (bottom sheet).
              SelectField(
                label: 'Hewan',
                options: names,
                value: selected?.name,
                // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
                onChanged: (name) => setState(() {
                  _petId = state.pets.firstWhere((p) => p.name == name).id;
                }),
              ),
              // jarak vertikal 14
              const SizedBox(height: 14),
              // FIELD PILIHAN «Jenis sesi»: diketuk membuka daftar opsi (bottom sheet).
              SelectField(
                label: 'Jenis sesi',
                options: kSessionTypes,
                value: _type,
                // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
                onChanged: (v) => setState(() => _type = v),
              ),
              // jarak vertikal 14
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    // FIELD PICKER «Tanggal»: diketuk membuka pemilih (tanggal/jam).
                    child: PickerField(
                      label: 'Tanggal',
                      value: fullShortDate(_date),
                      icon: Icons.calendar_month_outlined,
                      onTap: _pickDate,
                    ),
                  ),
                  // jarak horizontal 12
                  const SizedBox(width: 12),
                  Expanded(
                    // FIELD PICKER «Waktu»: diketuk membuka pemilih (tanggal/jam).
                    child: PickerField(
                      label: 'Waktu',
                      value: formatTime(_time),
                      icon: Icons.schedule,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              // jarak vertikal 14
              const SizedBox(height: 14),
              // FIELD INPUT «Petshop / penyedia»: controller menyimpan teks, validator = aturan validasi.
              AppTextField(
                label: 'Petshop / penyedia',
                controller: _provider,
                hint: 'Nama Petshop',
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Masukkan nama penyedia'
                    : null,
              ),
              // jarak vertikal 14
              const SizedBox(height: 14),
              // FIELD INPUT «Catatan · opsional»: controller menyimpan teks, validator = aturan validasi.
              AppTextField(
                label: 'Catatan · opsional',
                controller: _notes,
                hint: 'Tambahkan detail perawatan atau catatan kunjungan',
                maxLines: 3,
              ),
              // jarak vertikal 14
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Penilaian · opsional',
                      style: TextStyle(
                        color: AppTheme.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    _rating == 0
                        ? 'Belum dinilai'
                        : '${formatWeight(_rating)} / 5',
                    style: const TextStyle(
                      color: AppTheme.purpleDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              // jarak vertikal 6
              const SizedBox(height: 6),
              _StarRating(
                value: _rating,
                // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
                onChanged: (v) => setState(() => _rating = v),
              ),
              // jarak vertikal 24
              const SizedBox(height: 24),
              // TOMBOL «Simpan Sesi» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              AppButton(label: 'Simpan Sesi', onPressed: () => _save(state)),
              // TOMBOL TEKS «Batal» (LinkButton). onPressed = aksi saat ditekan.
              LinkButton(
                label: 'Batal',
                // NAVIGASI: kembali / tutup halaman atau sheet ini.
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Rating bintang, mendukung setengah bintang (ketuk sisi kiri/kanan bintang).
class _StarRating extends StatelessWidget {
  const _StarRating({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  static const _size = 34.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
          GestureDetector(
            onTapDown: (details) {
              final half = details.localPosition.dx < _size / 2;
              final next = i + (half ? 0.5 : 1.0);
              onChanged(next == value ? 0 : next);
            },
            child: SizedBox(
              width: _size,
              height: _size,
              child: Icon(
                value >= i + 1
                    ? Icons.star
                    : (value >= i + 0.5 ? Icons.star_half : Icons.star_border),
                color: const Color(0xFFF1B93B),
                size: 28,
              ),
            ),
          ),
      ],
    );
  }
}
