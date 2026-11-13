// ============================================================
// pet_form_screens.dart — TAMBAH, UBAH, dan TINJAU PINDAIAN HEWAN
// PetForm adalah satu form yang dipakai tiga halaman sekaligus.
// ============================================================

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'camera_screens.dart';

const kAnimalTypes = ['Kucing', 'Anjing', 'Kelinci', 'Burung', 'Lainnya'];
const kSexes = ['Jantan', 'Betina'];

/// The pet form shared by manual add, edit and "review scan".
class PetForm extends StatefulWidget {
  const PetForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.initial,
    this.initialType,
    this.initialBreed,
    this.scanLayout = false,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String submitLabel;
  final ValueChanged<Pet> onSubmit;
  final Pet? initial;
  final String? initialType;
  final String? initialBreed;

  /// Review-scan order: type + breed first, then the details a photo can't give.
  final bool scanLayout;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  State<PetForm> createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _breed;
  late final TextEditingController _weight;
  late final TextEditingController _age;
  String? _type;
  String? _sex;
  bool _tried = false;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _name = TextEditingController(text: p?.name ?? '');
    _breed = TextEditingController(text: p?.breed ?? widget.initialBreed ?? '');
    _weight = TextEditingController(
      text: p == null ? '' : formatWeight(p.weight),
    );
    _age = TextEditingController(text: p == null ? '' : p.age.toString());
    _type = p?.type ?? widget.initialType;
    _sex = p?.sex;
  }

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    _weight.dispose();
    _age.dispose();
    super.dispose();
  }

  void _submit() {
    // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
    setState(() => _tried = true);
    // VALIDASI form: true jika semua validator lolos.
    final fieldsOk = _formKey.currentState?.validate() ?? false;
    if (!fieldsOk || _type == null || _sex == null) return;
    widget.onSubmit(
      Pet(
        id:
            widget.initial?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        name: _name.text.trim(),
        type: _type!,
        sex: _sex!,
        breed: _breed.text.trim().isEmpty
            ? 'Tidak diketahui'
            : _breed.text.trim(),
        weight: double.parse(_weight.text.trim().replaceAll(',', '.')),
        age: int.parse(_age.text.trim()),
      ),
    );
  }

  String? _required(String? v, String message) =>
      v == null || v.trim().isEmpty ? message : null;

  // FIELD INPUT «Jenis hewan»: controller menyimpan teks, validator = aturan validasi.
  Widget _nameField() => AppTextField(
    label: widget.scanLayout ? 'Nama hewan · wajib' : 'Nama hewan',
    controller: _name,
    hint: 'Masukkan nama hewan',
    validator: (v) => _required(v, 'Masukkan nama hewanmu'),
  );

  // FIELD PILIHAN «Jenis hewan»: diketuk membuka daftar opsi (bottom sheet).
  Widget _typeField() => SelectField(
    label: 'Jenis hewan',
    options: kAnimalTypes,
    value: _type,
    errorText: _tried && _type == null ? 'Pilih jenis' : null,
    // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
    onChanged: (v) => setState(() => _type = v),
  );

  // FIELD PILIHAN «Ras»: diketuk membuka daftar opsi (bottom sheet).
  Widget _sexField() => SelectField(
    label: widget.scanLayout ? 'Jenis kelamin · perlu diisi' : 'Jenis kelamin',
    options: kSexes,
    value: _sex,
    errorText: _tried && _sex == null ? 'Pilih jenis kelamin' : null,
    // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
    onChanged: (v) => setState(() => _sex = v),
  );

  Widget _breedField() =>
      // FIELD INPUT «Ras»: controller menyimpan teks, validator = aturan validasi.
      AppTextField(label: 'Ras', controller: _breed, hint: 'Masukkan ras');

  // FIELD INPUT.
  Widget _weightField() => AppTextField(
    label: widget.scanLayout ? 'Berat · wajib' : 'Berat',
    controller: _weight,
    hint: 'Isi',
    suffix: 'kg',
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    validator: (v) {
      final n = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
      return n == null || n <= 0 ? 'Masukkan berat' : null;
    },
  );

  // FIELD INPUT.
  Widget _ageField() => AppTextField(
    label: widget.scanLayout ? 'Usia · wajib' : 'Usia',
    controller: _age,
    hint: 'Isi',
    suffix: 'tahun',
    keyboardType: TextInputType.number,
    validator: (v) {
      final n = int.tryParse((v ?? '').trim());
      return n == null || n < 0 ? 'Masukkan usia' : null;
    },
  );

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 14);
    const hgap = SizedBox(width: 12);
    final List<Widget> fields;
    if (widget.scanLayout) {
      fields = [
        Row(
          // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _typeField()),
            hgap,
            Expanded(child: _breedField()),
          ],
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        const Text(
          'Isi detail (nama, jenis kelamin, berat, dan usia) yang tidak bisa dikenali dari foto.',
          style: TextStyle(color: AppTheme.muted, fontSize: 11, height: 1.4),
        ),
        gap,
        _nameField(),
        gap,
        _sexField(),
        gap,
        Row(
          // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _weightField()),
            hgap,
            Expanded(child: _ageField()),
          ],
        ),
      ];
    } else {
      fields = [
        _nameField(),
        gap,
        Row(
          // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _typeField()),
            hgap,
            Expanded(child: _sexField()),
          ],
        ),
        gap,
        _breedField(),
        gap,
        Row(
          // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _weightField()),
            hgap,
            Expanded(child: _ageField()),
          ],
        ),
      ];
    }

    return Form(
      key: _formKey,
      child: Column(
        // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...fields,
          // jarak vertikal 22
          const SizedBox(height: 22),
          // TOMBOL (AppButton). onPressed = aksi saat ditekan.
          AppButton(label: widget.submitLabel, onPressed: _submit),
          if (widget.secondaryLabel != null)
            // PADDING: memberi ruang kosong di sekeliling child.
            Padding(
              // jarak dalam (padding): atas: 4
              padding: const EdgeInsets.only(top: 4),
              // TOMBOL TEKS (LinkButton).
              child: LinkButton(
                label: widget.secondaryLabel!,
                onPressed:
                    // NAVIGASI: kembali / tutup halaman atau sheet ini.
                    widget.onSecondary ?? () => Navigator.maybePop(context),
              ),
            ),
        ],
      ),
    );
  }
}

/// "Manual | Scan Photo" toggle shown on both add-pet screens.
class AddPetModeToggle extends StatelessWidget {
  const AddPetModeToggle({
    super.key,
    required this.scanSelected,
    required this.onChanged,
  });

  final bool scanSelected;
  final ValueChanged<bool> onChanged;

  Widget _segment(
    String label,
    IconData? icon,
    bool selected,
    VoidCallback onTap,
  ) {
    return Expanded(
      // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // tinggi 38 px
          height: 38,
          // posisi child: center
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppTheme.purple : Colors.transparent,
            // sudut membulat radius 13
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 15,
                  color: selected ? Colors.white : AppTheme.purpleDark,
                ),
                // jarak horizontal 5
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppTheme.purpleDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // jarak dalam (padding) 4 di semua sisi
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.lilac,
        // sudut membulat radius 16
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _segment('Manual', null, !scanSelected, () => onChanged(false)),
          _segment(
            'Pindai Foto',
            Icons.document_scanner_outlined,
            scanSelected,
            () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

/// Halaman Tambah Hewan (isi manual).
class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    return AppPage(
      title: 'Tambah Hewan',
      closeIcon: true,
      subtitle: 'Ceritakan sedikit tentang hewanmu.',
      children: [
        AddPetModeToggle(
          scanSelected: false,
          onChanged: (scan) {
            if (scan) {
              // NAVIGASI: ganti halaman ini dengan halaman baru (tidak bisa kembali ke sini).
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(builder: (_) => const ScanPetScreen()),
              );
            }
          },
        ),
        // jarak vertikal 18
        const SizedBox(height: 18),
        PetForm(
          submitLabel: 'Simpan Hewan',
          onSubmit: (pet) {
            state.addPet(pet);
            // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
            showAppMessage(context, '${pet.name} berhasil ditambahkan.');
            // NAVIGASI: kembali / tutup halaman atau sheet ini.
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

/// Halaman Ubah Hewan.
class EditPetScreen extends StatelessWidget {
  const EditPetScreen({super.key, required this.petId});

  final String petId;

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final pet = state.petById(petId);
    if (pet == null) return const Scaffold(backgroundColor: AppTheme.canvas);
    return AppPage(
      title: 'Ubah Hewan',
      closeIcon: true,
      subtitle: 'Perbarui profil ${pet.name}.',
      children: [
        WhiteCard(
          // jarak dalam (padding) 12 di semua sisi
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              PetAvatar(type: pet.type, size: 50),
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
                    // jarak vertikal 3
                    const SizedBox(height: 3),
                    // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
                    GestureDetector(
                      // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => TakePhotoScreen(petName: pet.name),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            size: 13,
                            color: AppTheme.purpleDark,
                          ),
                          // jarak horizontal 4
                          SizedBox(width: 4),
                          Text(
                            'Ganti foto',
                            style: TextStyle(
                              color: AppTheme.purpleDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
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
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        PetForm(
          initial: pet,
          submitLabel: 'Simpan perubahan',
          secondaryLabel: 'Batal',
          onSubmit: (updated) {
            state.updatePet(updated);
            // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
            showAppMessage(context, 'Perubahan tersimpan.');
            // NAVIGASI: kembali / tutup halaman atau sheet ini.
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

/// Halaman Tinjau pindaian: saran dari foto + data yang harus diisi sendiri.
class ReviewScanScreen extends StatelessWidget {
  const ReviewScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    return AppPage(
      title: 'Tinjau pindaian',
      closeIcon: true,
      subtitle: 'Perkiraan dari foto. Kamu yang menentukan detailnya.',
      children: [
        WhiteCard(
          // jarak dalam (padding) 12 di semua sisi
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const PetAvatar(type: 'Kucing', size: 50),
              // jarak horizontal 12
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Foto diambil',
                      style: TextStyle(
                        color: AppTheme.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    // jarak vertikal 2
                    SizedBox(height: 2),
                    Text(
                      'Saran · mohon konfirmasi',
                      style: TextStyle(color: AppTheme.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        // ALIGN: menempatkan child pada posisi tertentu (alignment).
        const Align(
          // posisi child: centerLeft
          alignment: Alignment.centerLeft,
          child: Pill(
            label: 'Saran sementara · bisa diubah',
            icon: Icons.auto_awesome,
          ),
        ),
        // jarak vertikal 12
        const SizedBox(height: 12),
        PetForm(
          scanLayout: true,
          initialType: 'Kucing',
          initialBreed: 'Persia',
          submitLabel: 'Konfirmasi & Simpan Hewan',
          secondaryLabel: 'Pindai ulang foto',
          // NAVIGASI: kembali / tutup halaman atau sheet ini.
          onSecondary: () => Navigator.pop(context),
          onSubmit: (pet) {
            state.addPet(pet);
            // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
            showAppMessage(context, '${pet.name} berhasil ditambahkan.');
            // NAVIGASI: kembali sampai halaman paling awal (beranda).
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ],
    );
  }
}
