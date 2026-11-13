// ============================================================
// phone_frame.dart — UKURAN CANVAS SEPERTI ANDROID
// Di layar lebar (web/desktop) aplikasi ditampilkan dalam kotak 400 x 860.
// Di ponsel asli (layar sempit) aplikasi memenuhi layar seperti biasa.
// ============================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// On wide screens (web / desktop) shows the whole app inside an Android-sized
/// canvas. On a real phone (narrow screen) the app simply fills the screen.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  static const double phoneWidth = 400;
  static const double phoneMaxHeight = 860;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) return child;

        final height = math.max(
          400.0,
          math.min(constraints.maxHeight - 24, phoneMaxHeight),
        );
        final media = MediaQuery.of(context);
        return ColoredBox(
          color: AppTheme.authBackdrop,
          child: Center(
            child: Container(
              width: phoneWidth,
              height: height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppTheme.canvas,
                // sudut membulat radius 32
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2557239A),
                    blurRadius: 32,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: MediaQuery(
                data: media.copyWith(size: Size(phoneWidth, height)),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
