import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/art.dart';

enum _AuthStage { welcome, login, signUp }

/// Alur login: welcome -> masuk / daftar dalam satu widget.
class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key, required this.onComplete});

  /// Called with the name typed by the person (empty for social login).
  final ValueChanged<String> onComplete;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  _AuthStage _stage = _AuthStage.welcome;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    // VALIDASI form: true jika semua validator lolos.
    if (_formKey.currentState?.validate() ?? false) {
      widget.onComplete(_nameController.text.trim());
    }
  }

  void _show(_AuthStage stage) {
    // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
    setState(() {
      _stage = stage;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWelcome = _stage == _AuthStage.welcome;
    final isSignUp = _stage == _AuthStage.signUp;

    // SCAFFOLD = kerangka satu halaman (background, body, dll.).
    return Scaffold(
      backgroundColor: isWelcome ? AppTheme.authWelcome : AppTheme.authPurple,
      // SAFEAREA: menjaga konten tidak tertutup poni/status bar/navigation bar.
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isWelcome ? AppTheme.authWelcome : AppTheme.authPurple,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: isWelcome
                          ? _buildWelcome(constraints.maxHeight)
                          : _buildAuthForm(isSignUp),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome(double available) {
    return SizedBox(
      height: math.max(available, 600),
      child: Column(
        // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 150, child: _WelcomeShapes()),
          // PADDING: memberi ruang kosong di sekeliling child.
          Padding(
            // jarak dalam (padding): kiri 28, atas 20, kanan 28, bawah 0
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
            child: Column(
              // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BulKu',
                  style: TextStyle(
                    color: AppTheme.authInk,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                // jarak vertikal 8
                const SizedBox(height: 8),
                const Text(
                  'Deskripsi ajalah apa ajawis ini mah contoh ajalah aku bingung namanya apa',
                  style: TextStyle(
                    color: Color(0xFF88889C),
                    fontSize: 14,
                    // tinggi 1.4 px
                    height: 1.4,
                  ),
                ),
                // jarak vertikal 36
                const SizedBox(height: 36),
                // TOMBOL «Daftar» halaman auth. onPressed = aksi saat ditekan.
                _AuthButton(
                  label: 'Daftar',
                  onPressed: () => _show(_AuthStage.signUp),
                ),
                // jarak vertikal 12
                const SizedBox(height: 12),
                // TOMBOL «Masuk» halaman auth. onPressed = aksi saat ditekan.
                _AuthButton(
                  label: 'Masuk',
                  outlined: true,
                  onPressed: () => _show(_AuthStage.login),
                ),
              ],
            ),
          ),
          Expanded(
            // ALIGN: menempatkan child pada posisi tertentu (alignment).
            child: Align(
              // posisi child: bottomCenter
              alignment: Alignment.bottomCenter,
              child: ClipRect(
                // ALIGN: menempatkan child pada posisi tertentu (alignment).
                child: Align(
                  // posisi child: topCenter
                  alignment: Alignment.topCenter,
                  heightFactor: 0.9,
                  child: const PurpleCat(width: 210),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm(bool isSignUp) {
    const gap = SizedBox(height: 12);
    // PADDING: memberi ruang kosong di sekeliling child.
    return Padding(
      // jarak dalam (padding): kiri 22, atas 22, kanan 22, bawah 18
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      child: Form(
        key: _formKey,
        child: Column(
          // rata tengah searah susunan (Row: kiri-kanan, Column: atas-bawah)
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PurpleCat(width: isSignUp ? 130 : 200),
            SizedBox(height: isSignUp ? 10 : 6),
            Text(
              isSignUp ? 'Buat akun' : 'Bersiaplah',
              style: const TextStyle(
                color: AppTheme.authInk,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (isSignUp) ...[
              // jarak vertikal 3
              const SizedBox(height: 3),
              const Text(
                'Perawatan kecil dimulai dari sini.',
                style: TextStyle(color: AppTheme.authSub, fontSize: 11),
              ),
            ],
            SizedBox(height: isSignUp ? 16 : 12),
            _field(
              controller: _nameController,
              label: 'Nama kamu',
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Masukkan nama kamu'
                  : null,
            ),
            gap,
            _field(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || !value.contains('@')
                  ? 'Masukkan email yang valid'
                  : null,
            ),
            gap,
            _field(
              controller: _passwordController,
              label: 'Kata sandi',
              obscureText: _hidePassword,
              suffix: _eye(
                _hidePassword,
                // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
                () => setState(() => _hidePassword = !_hidePassword),
              ),
              validator: (value) => value == null || value.length < 6
                  ? 'Gunakan minimal 6 karakter'
                  : null,
            ),
            if (isSignUp) ...[
              gap,
              _field(
                controller: _confirmPasswordController,
                label: 'Konfirmasi kata sandi',
                obscureText: _hideConfirmPassword,
                suffix: _eye(
                  _hideConfirmPassword,
                  // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
                  () => setState(
                    () => _hideConfirmPassword = !_hideConfirmPassword,
                  ),
                ),
                validator: (value) => value != _passwordController.text
                    ? 'Kata sandi tidak cocok'
                    : null,
              ),
              // jarak vertikal 14
              const SizedBox(height: 14),
              const Text(
                'Dengan mendaftar, kamu menyetujui\nSyarat Layanan dan Kebijakan Privasi kami.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.authSub,
                  fontSize: 9,
                  // tinggi 1.4 px
                  height: 1.4,
                ),
              ),
              // jarak vertikal 12
              const SizedBox(height: 12),
              // TOMBOL «Daftar» halaman auth. onPressed = aksi saat ditekan.
              _AuthButton(label: 'Daftar', onPressed: _submit),
              // jarak vertikal 8
              const SizedBox(height: 8),
              // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
              TextButton(
                onPressed: () => _show(_AuthStage.login),
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(color: AppTheme.authSub, fontSize: 11),
                    children: [
                      TextSpan(text: 'Sudah punya akun? '),
                      TextSpan(
                        text: 'Masuk',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // jarak vertikal 12
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    // TOMBOL login sosial «Facebook».
                    child: _SocialButton(
                      label: 'Facebook',
                      leading: const Icon(Icons.facebook, size: 18),
                      background: const Color(0xFF6D88CB),
                      foreground: Colors.white,
                      onPressed: () => widget.onComplete(''),
                    ),
                  ),
                  // jarak horizontal 10
                  const SizedBox(width: 10),
                  Expanded(
                    // TOMBOL login sosial «Google».
                    child: _SocialButton(
                      label: 'Google',
                      leading: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      background: Colors.white,
                      foreground: AppTheme.authInk,
                      onPressed: () => widget.onComplete(''),
                    ),
                  ),
                ],
              ),
              // jarak vertikal 12
              const SizedBox(height: 12),
              // TOMBOL «Masuk» halaman auth. onPressed = aksi saat ditekan.
              _AuthButton(label: 'Masuk', onPressed: _submit),
              // jarak vertikal 6
              const SizedBox(height: 6),
              // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
              TextButton(
                onPressed: () => _show(_AuthStage.signUp),
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(color: AppTheme.authSub, fontSize: 11),
                    children: [
                      TextSpan(text: "Belum punya akun? "),
                      TextSpan(
                        text: 'Daftar',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _eye(bool hidden, VoidCallback onTap) {
    // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: onTap,
      icon: Icon(
        hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 18,
        color: Colors.white70,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    // KOLOM INPUT (TextFormField): controller = isi teks, validator = aturan validasi, decoration = tampilan.
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Color(0xFFEAD8F7), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFB574E9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        suffixIcon: suffix,
        errorStyle: const TextStyle(color: Color(0xFF5E0F33), fontSize: 10),
        border: OutlineInputBorder(
          // sudut membulat radius 16
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// Tombol besar khusus halaman auth (ungu tua / outline).
class _AuthButton extends StatelessWidget {
  // TOMBOL halaman auth.
  const _AuthButton({
    required this.label,
    required this.onPressed,
    this.outlined = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      // sudut membulat radius 18
      borderRadius: BorderRadius.circular(18),
    );
    const textStyle = TextStyle(fontWeight: FontWeight.w800, fontSize: 16);
    return SizedBox(
      width: double.infinity,
      // tinggi 48 px
      height: 48,
      child: outlined
          // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.purpleDark,
                side: const BorderSide(color: AppTheme.purpleDark, width: 1.6),
                shape: shape,
              ),
              child: Text(label, style: textStyle),
            )
          // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
          : FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.purpleDark,
                foregroundColor: Colors.white,
                shape: shape,
              ),
              child: Text(label, style: textStyle),
            ),
    );
  }
}

/// Tombol Facebook / Google di halaman login.
class _SocialButton extends StatelessWidget {
  // TOMBOL login sosial.
  const _SocialButton({
    required this.label,
    required this.leading,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final String label;
  final Widget leading;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // tinggi 42 px
      height: 42,
      // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          // jarak dalam (padding): kiri-kanan: 8
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            // sudut membulat radius 14
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          // rata tengah searah susunan (Row: kiri-kanan, Column: atas-bawah)
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            // jarak horizontal 6
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeShapes extends StatelessWidget {
  const _WelcomeShapes();

  @override
  Widget build(BuildContext context) {
    // STACK: menumpuk widget (yang di bawah daftar = lapisan paling atas).
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
        Positioned(
          left: -80,
          top: -120,
          child: Container(
            // lebar 290 px
            width: 290,
            // tinggi 290 px
            height: 290,
            decoration: const BoxDecoration(
              color: Color(0xFFC9A5F5),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
        Positioned(
          right: -4,
          top: 62,
          child: Container(
            // lebar 76 px
            width: 76,
            // tinggi 76 px
            height: 76,
            decoration: const BoxDecoration(
              color: AppTheme.purpleDark,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
