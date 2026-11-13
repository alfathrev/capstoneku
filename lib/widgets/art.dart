// ============================================================
// art.dart — ILUSTRASI YANG DIGAMBAR LEWAT KODE (CustomPainter)
// Kucing ungu, kucing Arthur, latar teal, mock kamera, mock peta, grafik mini.
// Tidak memakai file gambar, jadi tidak perlu aset.
// ============================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Purple mascot used on the auth screens and as the profile icon.
class PurpleCat extends StatelessWidget {
  const PurpleCat({super.key, this.width = 160});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 0.8,
      child: CustomPaint(painter: _PurpleCatPainter()),
    );
  }
}

class _PurpleCatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 80);

    final head = Paint()..color = const Color(0xFFA25BE6);
    final earInner = Paint()..color = const Color(0xFFD7A6F4);
    final white = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF17162A);
    final brow = Paint()
      ..color = const Color(0xFF292039)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      Path()
        ..moveTo(5, 36)
        ..lineTo(11, 3)
        ..lineTo(44, 20)
        ..close(),
      head,
    );
    canvas.drawPath(
      Path()
        ..moveTo(95, 36)
        ..lineTo(89, 3)
        ..lineTo(56, 20)
        ..close(),
      head,
    );
    canvas.drawPath(
      Path()
        ..moveTo(13, 28)
        ..lineTo(15, 10)
        ..lineTo(32, 20)
        ..close(),
      earInner,
    );
    canvas.drawPath(
      Path()
        ..moveTo(87, 28)
        ..lineTo(85, 10)
        ..lineTo(68, 20)
        ..close(),
      earInner,
    );

    canvas.drawRRect(
      RRect.fromLTRBR(0, 14, 100, 78, const Radius.circular(30)),
      head,
    );

    for (final side in [-1.0, 1.0]) {
      final cx = 50 + side * 20;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, 45), width: 19, height: 23),
        white,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx - side, 46), width: 13, height: 17),
        pupil,
      );
      canvas.drawCircle(Offset(cx - side * 2.5, 40.5), 2.4, white);
      canvas.drawCircle(Offset(cx - side * 0.5, 51), 1.2, white);

      final browPath = Path()
        ..moveTo(50 + side * 30, 28)
        ..quadraticBezierTo(50 + side * 22, 21, 50 + side * 12, 26);
      canvas.drawPath(browPath, brow);
    }

    canvas.drawPath(
      Path()
        ..moveTo(48.3, 66)
        ..lineTo(51.7, 66)
        ..lineTo(50, 68.8)
        ..close(),
      pupil,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// "Arthur" – the grey tuxedo cat used for pet avatars and the detail header.
class CatPortrait extends StatelessWidget {
  const CatPortrait({super.key, this.size = 100, this.body = true});

  final double size;
  final bool body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRect(
        child: CustomPaint(painter: _CatPainter(body: body)),
      ),
    );
  }
}

class _CatPainter extends CustomPainter {
  const _CatPainter({required this.body});

  final bool body;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    final fur = Paint()..color = const Color(0xFF59627C);
    final furDark = Paint()..color = const Color(0xFF444C65);
    final white = Paint()..color = Colors.white;
    final pink = Paint()..color = const Color(0xFFF4A7BC);
    final yellow = Paint()..color = const Color(0xFFF6C744);
    final black = Paint()..color = const Color(0xFF1B1830);
    final stroke = Paint()
      ..color = const Color(0xFF1B1830)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final whisker = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..strokeCap = StrokeCap.round;

    if (body) {
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(50, 106), width: 96, height: 58),
        fur,
      );
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(50, 104), width: 34, height: 42),
        white,
      );
    }

    canvas.drawPath(
      Path()
        ..moveTo(14, 46)
        ..lineTo(19, 8)
        ..lineTo(45, 26)
        ..close(),
      fur,
    );
    canvas.drawPath(
      Path()
        ..moveTo(86, 46)
        ..lineTo(81, 8)
        ..lineTo(55, 26)
        ..close(),
      fur,
    );
    canvas.drawPath(
      Path()
        ..moveTo(21, 38)
        ..lineTo(23, 17)
        ..lineTo(37, 28)
        ..close(),
      pink,
    );
    canvas.drawPath(
      Path()
        ..moveTo(79, 38)
        ..lineTo(77, 17)
        ..lineTo(63, 28)
        ..close(),
      pink,
    );

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 52), width: 80, height: 66),
      fur,
    );
    canvas.drawPath(
      Path()
        ..moveTo(50, 22)
        ..lineTo(57, 44)
        ..lineTo(50, 50)
        ..lineTo(43, 44)
        ..close(),
      furDark,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 65), width: 42, height: 30),
      white,
    );

    for (final x in [34.0, 66.0]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, 46), width: 17, height: 15),
        yellow,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, 46), width: 5, height: 13),
        black,
      );
    }

    canvas.drawPath(
      Path()
        ..moveTo(46, 57)
        ..lineTo(54, 57)
        ..lineTo(50, 62)
        ..close(),
      pink,
    );
    canvas.drawLine(const Offset(50, 62), const Offset(50, 65), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(50, 65)
        ..quadraticBezierTo(46, 69, 42, 66),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(50, 65)
        ..quadraticBezierTo(54, 69, 58, 66),
      stroke,
    );

    for (final side in [-1.0, 1.0]) {
      canvas.drawLine(
        Offset(50 + side * 14, 63),
        Offset(50 + side * 40, 58),
        whisker,
      );
      canvas.drawLine(
        Offset(50 + side * 14, 66),
        Offset(50 + side * 40, 68),
        whisker,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CatPainter oldDelegate) =>
      oldDelegate.body != body;
}

/// Teal background with darker blobs (pet header + camera preview).
class TealBlobs extends StatelessWidget {
  const TealBlobs({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TealBlobsPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _TealBlobsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppTheme.teal);
    final dark = Paint()..color = AppTheme.tealDark.withValues(alpha: 0.7);
    const blobs = <List<double>>[
      [0.10, 0.22, 0.17],
      [0.88, 0.10, 0.13],
      [0.93, 0.58, 0.19],
      [0.06, 0.78, 0.14],
      [0.52, 0.02, 0.09],
      [0.30, 0.95, 0.10],
    ];
    for (final b in blobs) {
      canvas.drawCircle(
        Offset(size.width * b[0], size.height * b[1]),
        size.width * b[2],
        dark,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GuidePainter extends CustomPainter {
  const _GuidePainter({this.grid = false});

  final bool grid;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    const len = 26.0;
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(0, len)
      ..lineTo(0, 0)
      ..lineTo(len, 0)
      ..moveTo(w - len, 0)
      ..lineTo(w, 0)
      ..lineTo(w, len)
      ..moveTo(w, h - len)
      ..lineTo(w, h)
      ..lineTo(w - len, h)
      ..moveTo(len, h)
      ..lineTo(0, h)
      ..lineTo(0, h - len);
    canvas.drawPath(path, paint);

    if (grid) {
      final g = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..strokeWidth = 1;
      for (var i = 1; i < 3; i++) {
        canvas.drawLine(Offset(w * i / 3, 0), Offset(w * i / 3, h), g);
        canvas.drawLine(Offset(0, h * i / 3), Offset(w, h * i / 3), g);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GuidePainter oldDelegate) =>
      oldDelegate.grid != grid;
}

/// Static stand-in for a camera preview.
class CameraMock extends StatelessWidget {
  const CameraMock({
    super.key,
    this.height = 320,
    this.chip,
    this.label,
    this.grid = false,
  });

  final double height;
  final String? chip;
  final String? label;
  final bool grid;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // sudut membulat radius 24
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: height,
        width: double.infinity,
        // STACK: menumpuk widget (yang di bawah daftar = lapisan paling atas).
        child: Stack(
          fit: StackFit.expand,
          children: [
            const TealBlobs(),
            Center(child: CatPortrait(size: height * 0.55, body: false)),
            // PADDING: memberi ruang kosong di sekeliling child.
            Padding(
              // jarak dalam (padding) 22 di semua sisi
              padding: const EdgeInsets.all(22),
              child: CustomPaint(painter: _GuidePainter(grid: grid)),
            ),
            if (chip != null)
              // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(child: _OverlayChip(text: chip!)),
              ),
            if (label != null)
              // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
              Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: Center(child: _OverlayChip(text: label!)),
              ),
          ],
        ),
      ),
    );
  }
}

class _OverlayChip extends StatelessWidget {
  const _OverlayChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      // jarak dalam (padding): kiri-kanan: 12, atas-bawah: 5
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.purpleDark.withValues(alpha: 0.85),
        // sudut membulat radius 20
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Demo route preview drawn with shapes (no real map data).
class MapMock extends StatelessWidget {
  const MapMock({super.key, this.height = 250, required this.providerName});

  final double height;
  final String providerName;

  static const route = <List<double>>[
    [0.16, 0.82],
    [0.16, 0.58],
    [0.48, 0.58],
    [0.48, 0.30],
    [0.78, 0.30],
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // sudut membulat radius 22
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, c) {
            final start = Offset(
              c.maxWidth * route.first[0],
              height * route.first[1],
            );
            final end = Offset(
              c.maxWidth * route.last[0],
              height * route.last[1],
            );
            // STACK: menumpuk widget (yang di bawah daftar = lapisan paling atas).
            return Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _MapPainter())),
                // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
                Positioned(
                  left: start.dx - 7,
                  top: start.dy - 7,
                  child: Container(
                    // lebar 14 px
                    width: 14,
                    // tinggi 14 px
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppTheme.purpleDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
                // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
                Positioned(
                  left: start.dx + 12,
                  top: start.dy - 9,
                  child: const _MapLabel(text: 'You · demo start'),
                ),
                // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
                Positioned(
                  left: end.dx - 13,
                  top: end.dy - 32,
                  child: const Icon(
                    Icons.location_on,
                    color: AppTheme.purpleDark,
                    size: 34,
                  ),
                ),
                // POSITIONED: posisi absolut di dalam Stack (top/left/right/bottom = jarak dari tepi Stack).
                Positioned(
                  left: end.dx - 34,
                  top: end.dy - 54,
                  child: _MapLabel(text: providerName),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      // jarak dalam (padding): kiri-kanan: 7, atas-bawah: 3
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        // sudut membulat radius 8
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppTheme.softShadow,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: AppTheme.ink,
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFE9EEF6),
    );
    final green = Paint()..color = const Color(0xFFD0EDD9);
    final block = Paint()..color = const Color(0xFFDDE3EE);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    void rect(double l, double t, double r, double b, Paint p) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          size.width * l,
          size.height * t,
          size.width * r,
          size.height * b,
          const Radius.circular(10),
        ),
        p,
      );
    }

    rect(0.03, 0.05, 0.40, 0.45, green);
    rect(0.56, 0.52, 0.97, 0.95, green);
    rect(0.56, 0.05, 0.70, 0.22, block);
    rect(0.03, 0.66, 0.12, 0.95, block);
    rect(0.22, 0.66, 0.40, 0.95, block);
    rect(0.80, 0.05, 0.97, 0.22, block);

    canvas.drawLine(
      Offset(0, size.height * 0.58),
      Offset(size.width, size.height * 0.58),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.48, 0),
      Offset(size.width * 0.48, size.height),
      road,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.30),
      Offset(size.width, size.height * 0.30),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.16, 0),
      Offset(size.width * 0.16, size.height),
      road,
    );

    final routePaint = Paint()
      ..color = AppTheme.purpleDark
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    for (var i = 0; i < MapMock.route.length; i++) {
      final p = Offset(
        size.width * MapMock.route[i][0],
        size.height * MapMock.route[i][1],
      );
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Kotak dengan garis putus-putus (dipakai untuk kartu "Tambah Hewan").
class DashedRRect extends StatelessWidget {
  const DashedRRect({
    super.key,
    required this.child,
    this.color = AppTheme.purple,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DashedPainter(color), child: child);
  }
}

class _DashedPainter extends CustomPainter {
  const _DashedPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(18)),
      );
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final next = math.min(d + 5, metric.length);
        canvas.drawPath(metric.extractPath(d, next), paint);
        d = next + 4;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPainter oldDelegate) =>
      oldDelegate.color != color;
}

class WaveLine extends StatelessWidget {
  const WaveLine({super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _WavePainter(),
    size: const Size(double.infinity, 26),
  );
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final path = Path()..moveTo(0, size.height / 2);
    for (var x = 0.0; x <= size.width; x += 2) {
      path.lineTo(
        x,
        size.height / 2 +
            math.sin(x / size.width * math.pi * 3) * size.height * 0.4,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MiniBars extends StatelessWidget {
  const MiniBars({super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _BarsPainter(),
    size: const Size(double.infinity, 28),
  );
}

class _BarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const heights = [
      0.35,
      0.6,
      0.45,
      0.8,
      0.55,
      0.95,
      0.7,
      0.5,
      0.85,
      0.6,
      0.75,
      0.4,
    ];
    final paint = Paint()..color = AppTheme.purple.withValues(alpha: 0.9);
    final slot = size.width / heights.length;
    for (var i = 0; i < heights.length; i++) {
      final h = size.height * heights[i];
      canvas.drawRRect(
        RRect.fromLTRBR(
          i * slot + slot * 0.2,
          size.height - h,
          i * slot + slot * 0.7,
          size.height,
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
