// ============================================================
// app_widgets.dart — KOMPONEN UI YANG DIPAKAI BERULANG
// Catatan cara membaca layout Flutter di file ini:
// - Row = susun ke samping, Column = susun ke bawah.
// - Expanded = mengisi sisa ruang yang tersedia di Row/Column.
// - Padding / EdgeInsets = jarak DALAM. EdgeInsets.fromLTRB(kiri, atas, kanan, bawah).
// - SizedBox(height/width) = jarak kosong atau ukuran tetap.
// - Container margin = jarak LUAR, Container padding = jarak DALAM.
// ============================================================

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'art.dart';

void showAppMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    // SNACKBAR: pesan singkat di bawah layar.
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}

/// Standard sub-page: back/close button, title, optional subtitle, scrolling body.
class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.closeIcon = false,
    this.trailing,
    this.footer,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final bool closeIcon;
  final Widget? trailing;
  final List<Widget> children;
  final Widget? footer;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    // SCAFFOLD = kerangka satu halaman (background, body, dll.).
    return Scaffold(
      backgroundColor: AppTheme.canvas,
      // SAFEAREA: menjaga konten tidak tertutup poni/status bar/navigation bar.
      body: SafeArea(
        child: Column(
          children: [
            // PADDING: memberi ruang kosong di sekeliling child.
            Padding(
              // jarak dalam (padding): kiri 8, atas 6, kanan 14, bawah 4
              padding: const EdgeInsets.fromLTRB(8, 6, 14, 4),
              child: Row(
                children: [
                  // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
                  IconButton(
                    // NAVIGASI: kembali / tutup halaman atau sheet ini.
                    onPressed: onBack ?? () => Navigator.maybePop(context),
                    icon: Icon(
                      closeIcon ? Icons.close : Icons.arrow_back,
                      color: AppTheme.purpleDark,
                      size: 22,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            Expanded(
              // LISTVIEW: daftar yang bisa di-scroll; padding = jarak di sekeliling isi.
              child: ListView(
                // jarak dalam (padding): kiri 18, atas 4, kanan 18, bawah 24
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                children: [
                  if (subtitle != null)
                    // PADDING: memberi ruang kosong di sekeliling child.
                    Padding(
                      // jarak dalam (padding): bawah: 14
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(
                        subtitle!,
                        style: const TextStyle(
                          color: AppTheme.muted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ...children,
                ],
              ),
            ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

/// Judul bagian (mis. "Riwayat Sesi") dengan tautan aksi kecil di kanan (mis. "Buat").
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (actionLabel != null)
          // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            // PADDING: memberi ruang kosong di sekeliling child.
            child: Padding(
              // jarak dalam (padding): atas-bawah: 6, kiri-kanan: 2
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  color: AppTheme.purple,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum AppButtonKind { primary, dark, soft, danger, dangerSoft, outline }

/// TOMBOL utama aplikasi. kind menentukan warna, onPressed = aksi saat ditekan, height = tinggi tombol.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = AppButtonKind.primary,
    this.icon,
    this.height = 46,
    this.fontSize = 13,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonKind kind;
  final IconData? icon;
  final double height;
  final double fontSize;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    Color bg = AppTheme.purple;
    Color fg = Colors.white;
    Color? border;
    switch (kind) {
      case AppButtonKind.primary:
        break;
      case AppButtonKind.dark:
        bg = AppTheme.purpleDark;
      case AppButtonKind.soft:
        bg = AppTheme.lilac;
        fg = AppTheme.purpleDark;
      case AppButtonKind.danger:
        bg = AppTheme.rose;
      case AppButtonKind.dangerSoft:
        bg = AppTheme.roseSoft;
        fg = AppTheme.rose;
      case AppButtonKind.outline:
        bg = Colors.transparent;
        fg = AppTheme.purpleDark;
        border = AppTheme.purpleDark;
    }
    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withValues(alpha: 0.5),
          elevation: 0,
          // jarak dalam (padding): kiri-kanan: 16
          padding: const EdgeInsets.symmetric(horizontal: 16),
          minimumSize: Size(expand ? 0.0 : 64.0, height),
          side: border == null ? null : BorderSide(color: border, width: 1.6),
          shape: RoundedRectangleBorder(
            // sudut membulat radius height > 40 ? 16 : 12
            borderRadius: BorderRadius.circular(height > 40 ? 16 : 12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // rata tengah searah susunan (Row: kiri-kanan, Column: atas-bawah)
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: fontSize + 3),
              // jarak horizontal 6
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tombol teks di tengah (mis. "Batal"). Dipakai untuk aksi sekunder.
class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppTheme.purpleDark,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Kartu putih membulat dengan bayangan. padding = jarak isi, radius = kelengkungan sudut, onTap = bisa diketuk.
class WhiteCard extends StatelessWidget {
  const WhiteCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color = Colors.white,
    this.radius = 18,
    this.onTap,
    this.shadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double radius;
  final VoidCallback? onTap;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: r,
        boxShadow: shadow ? AppTheme.softShadow : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        // INKWELL: area yang bisa diketuk dengan efek riak (onTap).
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Label kecil membulat (chip statis), mis. "Demo" atau "Dokter tersedia".
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.icon,
    this.bg = AppTheme.lilac,
    this.fg = AppTheme.purpleDark,
    this.fontSize = 10,
  });

  final String label;
  final IconData? icon;
  final Color bg;
  final Color fg;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      // jarak dalam (padding): kiri-kanan: 9, atas-bawah: 4
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        // sudut membulat radius 20
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: fg),
            // jarak horizontal 4
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Selectable chip used for filters, dates and time slots.
class ChoiceTag extends StatelessWidget {
  const ChoiceTag({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // jarak dalam (padding): kiri-kanan: 13, atas-bawah: 8
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.purpleDark : Colors.white,
          // sudut membulat radius 20
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.purpleDark : AppTheme.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13,
                color: selected ? Colors.white : AppTheme.purpleDark,
              ),
              // jarak horizontal 5
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppTheme.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _labelStyle = TextStyle(
  color: AppTheme.muted,
  fontSize: 11,
  fontWeight: FontWeight.w600,
);

InputDecoration fieldDecoration({
  String? hint,
  String? suffixText,
  Widget? prefixIcon,
}) {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
    // sudut membulat radius 14
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: color),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFB4B3C4), fontSize: 13),
    suffixText: suffixText,
    suffixStyle: const TextStyle(color: AppTheme.muted, fontSize: 12),
    prefixIcon: prefixIcon,
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: border(AppTheme.line),
    focusedBorder: border(AppTheme.purple),
    errorBorder: border(AppTheme.rose),
    focusedErrorBorder: border(AppTheme.rose),
    errorStyle: const TextStyle(color: AppTheme.rose, fontSize: 10),
  );
}

/// Kolom input teks dengan label di atas. validator = aturan validasi, controller = penyimpan teks.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.suffix,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        // jarak vertikal 5
        const SizedBox(height: 5),
        // KOLOM INPUT (TextFormField): controller = isi teks, validator = aturan validasi, decoration = tampilan.
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          readOnly: readOnly,
          style: const TextStyle(color: AppTheme.ink, fontSize: 13),
          decoration: fieldDecoration(hint: hint, suffixText: suffix),
        ),
      ],
    );
  }
}

/// Tap-to-choose field that opens a bottom sheet with the options.
class SelectField extends StatelessWidget {
  const SelectField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.hint = 'Select',
    this.errorText,
  });

  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;
  final String hint;
  final String? errorText;

  Future<void> _open(BuildContext context) async {
    // BOTTOM SHEET: panel yang naik dari bawah layar.
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      // SAFEAREA: menjaga konten tidak tertutup poni/status bar/navigation bar.
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in options)
                ListTile(
                  title: Text(
                    option,
                    style: const TextStyle(color: AppTheme.ink),
                  ),
                  trailing: option == value
                      ? const Icon(Icons.check, color: AppTheme.purple)
                      : null,
                  // NAVIGASI: kembali / tutup halaman atau sheet ini.
                  onTap: () => Navigator.pop(sheetContext, option),
                ),
              // jarak vertikal 8
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        // jarak vertikal 5
        const SizedBox(height: 5),
        // INKWELL: area yang bisa diketuk dengan efek riak (onTap).
        InkWell(
          // sudut membulat radius 14
          borderRadius: BorderRadius.circular(14),
          onTap: () => _open(context),
          child: Container(
            // tinggi 48 px
            height: 48,
            // jarak dalam (padding): kiri-kanan: 14
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              // sudut membulat radius 14
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: errorText == null ? AppTheme.line : AppTheme.rose,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: value == null
                          ? const Color(0xFFB4B3C4)
                          : AppTheme.ink,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.muted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          // PADDING: memberi ruang kosong di sekeliling child.
          Padding(
            // jarak dalam (padding): atas: 4, kiri: 4
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: AppTheme.rose, fontSize: 10),
            ),
          ),
      ],
    );
  }
}

/// Read-only styled value that looks like a field (date / time pickers).
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        // jarak vertikal 5
        const SizedBox(height: 5),
        // INKWELL: area yang bisa diketuk dengan efek riak (onTap).
        InkWell(
          // sudut membulat radius 14
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            // tinggi 48 px
            height: 48,
            // jarak dalam (padding): kiri-kanan: 14
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              // sudut membulat radius 14
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.line),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(color: AppTheme.ink, fontSize: 13),
                  ),
                ),
                if (icon != null) Icon(icon, color: AppTheme.muted, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Square pet avatar on the teal background.
class PetAvatar extends StatelessWidget {
  const PetAvatar({super.key, required this.type, this.size = 48});

  final String type;
  final double size;

  static String emojiFor(String type) {
    switch (type) {
      case 'Anjing':
        return '🐕';
      case 'Kelinci':
        return '🐇';
      case 'Burung':
        return '🐦';
      default:
        return '🐾';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // sudut membulat radius size * 0.27
      borderRadius: BorderRadius.circular(size * 0.27),
      child: SizedBox(
        width: size,
        height: size,
        // STACK: menumpuk widget (yang di bawah daftar = lapisan paling atas).
        child: Stack(
          fit: StackFit.expand,
          children: [
            const TealBlobs(),
            Center(
              child: type == 'Kucing'
                  ? CatPortrait(size: size * 0.92, body: false)
                  : Text(
                      emojiFor(type),
                      style: TextStyle(fontSize: size * 0.5),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Round user avatar: initial or the mascot when a photo has been "added".
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.initial,
    this.hasPhoto = false,
    this.size = 44,
  });

  final String initial;
  final bool hasPhoto;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      // posisi child: center
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFD9B8F5),
        shape: BoxShape.circle,
      ),
      child: hasPhoto
          ? ClipOval(
              child: SizedBox(
                width: size,
                height: size,
                child: Center(child: PurpleCat(width: size * 0.82)),
              ),
            )
          : Text(
              initial,
              style: TextStyle(
                color: AppTheme.purpleDark,
                fontSize: size * 0.42,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

/// Bottom row of three capture controls (camera screens).
class CaptureControls extends StatelessWidget {
  const CaptureControls({
    super.key,
    required this.leftIcon,
    required this.leftLabel,
    required this.onLeft,
    required this.rightIcon,
    required this.rightLabel,
    required this.onRight,
    required this.onShutter,
  });

  final IconData leftIcon;
  final String leftLabel;
  final VoidCallback onLeft;
  final IconData rightIcon;
  final String rightLabel;
  final VoidCallback onRight;
  final VoidCallback onShutter;

  Widget _side(IconData icon, String label, VoidCallback onTap) {
    // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        // lebar 70 px
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.purpleDark, size: 22),
            // jarak vertikal 3
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(color: AppTheme.muted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // item tersebar dengan jarak sama rata
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _side(leftIcon, leftLabel, onLeft),
        // GESTUREDETECTOR: membuat widget di bawahnya bisa diketuk (onTap).
        GestureDetector(
          onTap: onShutter,
          child: Container(
            // lebar 66 px
            width: 66,
            // tinggi 66 px
            height: 66,
            // jarak dalam (padding) 4 di semua sisi
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.purple, width: 3),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.purple,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        _side(rightIcon, rightLabel, onRight),
      ],
    );
  }
}
