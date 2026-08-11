import 'package:flutter/widgets.dart';

/// Escala de espaciados. Todo padding/margin/gap sale de aquí,
/// para que tarjetas, botones y modales respiren igual en toda la app.
///
/// Basada en múltiplos de 4 (RNF-09: usabilidad con una mano — los objetivos
/// táctiles y sus separaciones quedan definidos desde un único lugar).
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Altura mínima de un objetivo táctil cómodo para el pulgar.
  static const double touchTarget = 48;

  // Gaps listos para usar en Column/Row.
  static const SizedBox gapXs = SizedBox(height: xs, width: xs);
  static const SizedBox gapSm = SizedBox(height: sm, width: sm);
  static const SizedBox gapMd = SizedBox(height: md, width: md);
  static const SizedBox gapLg = SizedBox(height: lg, width: lg);
}

/// Radios de esquina consistentes para tarjetas, botones, campos y chips.
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius fieldRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chipRadius = BorderRadius.all(Radius.circular(pill));
}
