import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Verificar se é mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  // Verificar se é tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  // Verificar se é desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  // Obter largura da tela
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Obter altura da tela
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Obter padding responsivo
  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  // Obter largura máxima do conteúdo
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return screenWidth(context);
    } else if (isTablet(context)) {
      return 700;
    } else {
      return 900;
    }
  }

  // Obter número de colunas para grid
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  // Obter tamanho de fonte responsivo
  static double getFontSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize;
    } else if (isTablet(context)) {
      return baseSize * 1.1;
    } else {
      return baseSize * 1.2;
    }
  }

  // Obter largura do card
  static double getCardWidth(BuildContext context) {
    if (isMobile(context)) {
      return screenWidth(context) * 0.9;
    } else if (isTablet(context)) {
      return 600;
    } else {
      return 700;
    }
  }

  // Obter aspect ratio do card de produto
  static double getProductCardAspectRatio(BuildContext context) {
    if (isMobile(context)) {
      return 0.75;
    } else if (isTablet(context)) {
      return 0.85;
    } else {
      return 0.9;
    }
  }

  // Layout responsivo personalizado
  static T valueByScreen<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
}