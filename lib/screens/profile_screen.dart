// ============================================================
// profile_screen.dart — PROFIL SAYA, UBAH PROFIL, GANTI FOTO
// ============================================================

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/art.dart';

void showChangePhotoSheet(BuildContext context) {
  // Mengambil AppState (data pet, sesi, profil) dari AppScope.
  final state = AppScope.of(context);
  final messenger = ScaffoldMessenger.of(context);

  void choose(BuildContext sheetContext, bool hasPhoto, String message) {
    state.profile.hasPhoto = hasPhoto;
    state.touchProfile();
    // NAVIGASI: kembali / tutup halaman atau sheet ini.
    Navigator.pop(sheetContext);
    messenger
      ..hideCurrentSnackBar()
      // SNACKBAR: pesan singkat di bawah layar.
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget option(
    BuildContext sheetContext,
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color color = AppTheme.ink,
  }) {
    // PADDING: memberi ruang kosong di sekeliling child.
    return Padding(
      // jarak dalam (padding): bawah: 8
      padding: const EdgeInsets.only(bottom: 8),
      child: WhiteCard(
        color: AppTheme.canvas,
        shadow: false,
        radius: 14,
        // jarak dalam (padding): kiri-kanan: 14, atas-bawah: 14
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color == AppTheme.ink ? AppTheme.purpleDark : color,
            ),
            // jarak horizontal 12
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        // jarak dalam (padding): kiri 22, atas 0, kanan 22, bawah 14
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ganti foto profil',
              style: TextStyle(
                color: AppTheme.ink,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            // jarak vertikal 3
            const SizedBox(height: 3),
            const Text(
              'Pilih cara menambahkan fotomu.',
              style: TextStyle(color: AppTheme.muted, fontSize: 12),
            ),
            // jarak vertikal 14
            const SizedBox(height: 14),
            option(
              sheetContext,
              Icons.photo_camera_outlined,
              'Ambil foto',
              () =>
                  choose(sheetContext, true, 'Foto profil diperbarui (demo).'),
            ),
            option(
              sheetContext,
              Icons.photo_library_outlined,
              'Pilih dari galeri',
              () =>
                  choose(sheetContext, true, 'Foto profil diperbarui (demo).'),
            ),
            option(
              sheetContext,
              Icons.delete_outline,
              'Hapus foto',
              () => choose(sheetContext, false, 'Foto profil dihapus.'),
              color: AppTheme.rose,
            ),
            // jarak vertikal 4
            const SizedBox(height: 4),
            // TOMBOL «Batal» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
            AppButton(
              label: 'Batal',
              kind: AppButtonKind.soft,
              // NAVIGASI: kembali / tutup halaman atau sheet ini.
              onPressed: () => Navigator.pop(sheetContext),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ProfileHeaderIcon extends StatelessWidget {
  const _ProfileHeaderIcon();

  @override
  Widget build(BuildContext context) => const PurpleCat(width: 30);
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.state,
    required this.title,
    required this.onChangePhoto,
  });

  final AppState state;
  final String title;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    final p = state.profile;
    return WhiteCard(
      // jarak dalam (padding) 14 di semua sisi
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          ProfileAvatar(initial: p.initial, hasPhoto: p.hasPhoto, size: 58),
          // jarak horizontal 14
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: p.fullName.isEmpty && title == 'Nama lengkap kamu'
                        ? AppTheme.muted
                        : AppTheme.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '@${p.username}',
                  style: const TextStyle(
                    color: AppTheme.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // jarak vertikal 5
                const SizedBox(height: 5),
                // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
                GestureDetector(
                  onTap: onChangePhoto,
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
    );
  }
}

/// Halaman Profil Saya.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _row(IconData icon, String label, String value, {bool last = false}) {
    final empty = value.isEmpty;
    // PADDING: memberi ruang kosong di sekeliling child.
    return Padding(
      // jarak dalam (padding): bawah: last ? 0 : 14
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Row(
        children: [
          Container(
            // lebar 34 px
            width: 34,
            // tinggi 34 px
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.lilac,
              // sudut membulat radius 11
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 17, color: AppTheme.purple),
          ),
          // jarak horizontal 12
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 10),
                ),
                // jarak vertikal 1
                const SizedBox(height: 1),
                Text(
                  empty ? 'Belum diisi' : value,
                  style: TextStyle(
                    color: empty ? AppTheme.muted : AppTheme.ink,
                    fontSize: 13,
                    fontWeight: empty ? FontWeight.w500 : FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final p = state.profile;
    return AppPage(
      title: 'Profil Saya',
      subtitle: 'Sedikit tentang kamu, si pemilik hewan.',
      trailing: const _ProfileHeaderIcon(),
      // PADDING: memberi ruang kosong di sekeliling child.
      footer: Padding(
        // jarak dalam (padding): kiri 18, atas 0, kanan 18, bawah 16
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
        // TOMBOL «Ubah profil» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
        child: AppButton(
          label: 'Ubah profil',
          // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const EditProfileScreen()),
          ),
        ),
      ),
      children: [
        _ProfileCard(
          state: state,
          title: p.fullName.isEmpty ? 'Nama lengkap kamu' : p.fullName,
          onChangePhoto: () => showChangePhotoSheet(context),
        ),
        // jarak vertikal 20
        const SizedBox(height: 20),
        const SectionHeading(title: 'Detail akun'),
        // jarak vertikal 8
        const SizedBox(height: 8),
        WhiteCard(
          // jarak dalam (padding) 14 di semua sisi
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _row(Icons.phone_outlined, 'Nomor telepon', p.phone),
              _row(Icons.mail_outline, 'Email', p.email, last: true),
            ],
          ),
        ),
        // jarak vertikal 20
        const SizedBox(height: 20),
        const SectionHeading(title: 'Detail pribadi'),
        // jarak vertikal 8
        const SizedBox(height: 8),
        WhiteCard(
          // jarak dalam (padding) 14 di semua sisi
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _row(Icons.location_on_outlined, 'Lokasi', p.location),
              _row(Icons.place_outlined, 'Tempat lahir', p.placeOfBirth),
              _row(
                Icons.cake_outlined,
                'Tanggal lahir',
                p.dateOfBirth,
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Halaman Ubah Profil (form dengan banyak controller).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullName;
  late final TextEditingController _username;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _location;
  late final TextEditingController _birthPlace;
  late final TextEditingController _birthDate;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final p = AppScope.of(context).profile;
    _fullName = TextEditingController(text: p.fullName);
    _username = TextEditingController(text: p.username);
    _phone = TextEditingController(text: p.phone);
    _email = TextEditingController(text: p.email);
    _location = TextEditingController(text: p.location);
    _birthPlace = TextEditingController(text: p.placeOfBirth);
    _birthDate = TextEditingController(text: p.dateOfBirth);
  }

  @override
  void dispose() {
    for (final c in [
      _fullName,
      _username,
      _phone,
      _email,
      _location,
      _birthPlace,
      _birthDate,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    // VALIDASI form: true jika semua validator lolos.
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    final p = state.profile;
    p.fullName = _fullName.text.trim();
    p.username = _username.text.trim().replaceAll('@', '');
    p.phone = _phone.text.trim();
    p.email = _email.text.trim();
    p.location = _location.text.trim();
    p.placeOfBirth = _birthPlace.text.trim();
    p.dateOfBirth = _birthDate.text.trim();
    state.touchProfile();
    // SNACKBAR: pesan singkat di bawah layar (showAppMessage ada di app_widgets.dart).
    showAppMessage(context, 'Profil diperbarui.');
    // NAVIGASI: kembali / tutup halaman atau sheet ini.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final state = AppScope.of(context);
    const gap = SizedBox(height: 14);
    return AppPage(
      title: 'Ubah Profil',
      subtitle: 'Perbarui detail pribadimu.',
      trailing: const _ProfileHeaderIcon(),
      children: [
        _ProfileCard(
          state: state,
          title: state.profile.fullName.isEmpty
              ? 'Nama lengkap kamu'
              : state.profile.fullName,
          onChangePhoto: () => showChangePhotoSheet(context),
        ),
        // jarak vertikal 18
        const SizedBox(height: 18),
        Form(
          key: _formKey,
          child: Column(
            children: [
              // FIELD INPUT «Nama lengkap»: controller menyimpan teks, validator = aturan validasi.
              AppTextField(
                label: 'Nama lengkap',
                controller: _fullName,
                hint: 'Masukkan nama lengkap',
              ),
              gap,
              // FIELD INPUT «Nama pengguna»: controller menyimpan teks, validator = aturan validasi.
              AppTextField(
                label: 'Nama pengguna',
                controller: _username,
                hint: 'fathrev',
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Nama pengguna tidak boleh kosong'
                    : null,
              ),
              gap,
              // FIELD INPUT «Nomor telepon»: controller menyimpan teks, validator = aturan validasi.
              AppTextField(
                label: 'Nomor telepon',
                controller: _phone,
                hint: 'Masukkan nomor telepon',
                keyboardType: TextInputType.phone,
              ),
              gap,
              // FIELD INPUT «Email»: controller menyimpan teks, validator = aturan validasi.
              AppTextField(
                label: 'Email',
                controller: _email,
                hint: 'Masukkan alamat email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v != null && v.trim().isNotEmpty && !v.contains('@')
                    ? 'Masukkan email yang valid'
                    : null,
              ),
              gap,
              // FIELD INPUT «Lokasi»: controller menyimpan teks, validator = aturan validasi.
              AppTextField(
                label: 'Lokasi',
                controller: _location,
                hint: 'Kota, negara',
              ),
              gap,
              Row(
                // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // FIELD INPUT «Tempat lahir»: controller menyimpan teks, validator = aturan validasi.
                    child: AppTextField(
                      label: 'Tempat lahir',
                      controller: _birthPlace,
                      hint: 'Kota, negara',
                    ),
                  ),
                  // jarak horizontal 12
                  const SizedBox(width: 12),
                  Expanded(
                    // FIELD INPUT «Tanggal lahir»: controller menyimpan teks, validator = aturan validasi.
                    child: AppTextField(
                      label: 'Tanggal lahir',
                      controller: _birthDate,
                      hint: 'DD/MM/YYYY',
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ],
              ),
              // jarak vertikal 24
              const SizedBox(height: 24),
              // TOMBOL «Simpan perubahan» (AppButton). onPressed = aksi saat ditekan; height/fontSize = ukuran tombol.
              AppButton(label: 'Simpan perubahan', onPressed: _save),
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
