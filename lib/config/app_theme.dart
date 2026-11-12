import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color bgCanvasDark = Color(0xFF042424);
  static const Color bgHeroTop = Color(0xFF021B1C);
  static const Color bgHeroMid = Color(0xFF0E423D);
  static const Color bgHeroEnd = Color(0xFF196452);

  static const Color bgLabWhite = Color(0xFFF3F8EE);
  static const Color bgSurfaceMuted = Color(0xFFEAF6DC);
  static const Color bgCardWhite = Color(0xFFFFFFFF);
  static const Color bgCardDark = Color(0xFF072C2A);

  static const Color greenMid = Color(0xFF145947);
  static const Color greenBright = Color(0xFF258562);
  static const Color mintPistachio = Color(0xFFDFF5C2);
  static const Color mintMid = Color(0xFFBFE99E);
  static const Color mintDeep = Color(0xFF8ED485);

  static const Color textMutedDark = Color(0xFFC6E6CE);
  static const Color textSecondaryLight = Color(0xFF1D3B32);
  static const Color blackInk = Color(0xFF070D0B);
  static const Color whitePure = Color(0xFFFFFFFF);
  static const Color errorRed = Color(0xFFB42318);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgHeroTop, Color(0xFF062928), bgHeroMid, bgHeroEnd],
    stops: [0.0, 0.3, 0.65, 1.0],
  );

  static const LinearGradient sectionAltGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF062827), Color(0xFF0B3834), Color(0xFF124E44)],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mintPistachio, mintMid, mintDeep],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF062B29), Color(0xFF0D423D), Color(0xFF165B4C)],
  );
}

class AppTheme {
  static TextStyle ubuntu({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.ubuntu(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle mono({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static BoxDecoration brutalCard({
    Color color = AppColors.whitePure,
    double radius = 16,
    double shadowOffset = 4,
    Color borderColor = AppColors.blackInk,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: 2.5),
      boxShadow: [
        BoxShadow(
          color: AppColors.blackInk,
          offset: Offset(shadowOffset, shadowOffset),
          blurRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration brutalMint({
    double radius = 12,
    double shadowOffset = 2.5,
  }) {
    return BoxDecoration(
      gradient: AppColors.mintGradient,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.blackInk, width: 2.5),
      boxShadow: [
        BoxShadow(
          color: AppColors.blackInk,
          offset: Offset(shadowOffset, shadowOffset),
          blurRadius: 0,
        ),
      ],
    );
  }

  static ThemeData buildTheme({required bool isLightLab}) {
    final baseBg = isLightLab ? AppColors.bgLabWhite : AppColors.bgCanvasDark;
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: baseBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.greenMid,
        brightness: isLightLab ? Brightness.light : Brightness.dark,
      ),
      fontFamily: GoogleFonts.ubuntu().fontFamily,
    );
  }
}
