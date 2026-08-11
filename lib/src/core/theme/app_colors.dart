import 'package:flutter/material.dart';

/// Paleta de colores de la app (design system — Etapa 0).
///
/// Un solo lugar donde viven los colores. Ninguna pantalla debe usar
/// `Color(0x...)` directo: siempre a través de esta clase o del [ThemeData].
class AppColors {
  AppColors._();

  // --- Marca / primario ---
  /// Color principal de la app (acciones, énfasis, barra activa).
  static const Color primary = Color(0xFF7C5CFF); // Violeta de marca
  static const Color primaryLight = Color(0xFFB59BFF); // hover/disabled, acentos
  static const Color primaryDark = Color(0xFF5F3FE0); // press state
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Resalte cálido puntual (badges, tajada "sobrante").
  static const Color highlight = Color(0xFFFFC857);

  /// Accent suave: morado muy sutil, casi blanco pero distinguible (cards de
  /// ánimo). En oscuro, un violeta apagado apenas por encima de la superficie.
  static const Color accentLight = Color(0xFFF1ECFF);
  static const Color accentDark = Color(0xFF322B54);

  // --- Semánticos ---
  /// Positivo / éxito / disponible en verde (saldo a favor).
  static const Color positive = Color(0xFF4CC38A);
  static const Color positiveSurface = Color(0xFFE3F6EE);

  /// Alerta / negativo (disponible en rojo, sobregiro).
  static const Color negative = Color(0xFFE0483B);
  static const Color negativeSurface = Color(0xFFFCE9E7);

  /// Advertencia (uso de sobre acercándose al límite, 80%+).
  static const Color warning = Color(0xFFE8A020);
  static const Color warningSurface = Color(0xFFFDF3E1);

  // --- Neutros: modo claro ---
  // Fondo blanco: en claro las cards e inputs se distinguen por su borde, no
  // por contraste de fondo (bg == surface).
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFEDEFF3);
  static const Color textPrimaryLight = Color(0xFF1E1E2F);
  static const Color textSecondaryLight = Color(0xFF5B6472);
  static const Color borderLight = Color(0xFFE2E5EB);

  // --- Neutros: modo oscuro ---
  static const Color backgroundDark = Color(0xFF15141F);
  static const Color surfaceDark = Color(0xFF211F2E);
  static const Color surfaceVariantDark = Color(0xFF2C2A3B);
  static const Color textPrimaryDark = Color(0xFFF2F3F7);
  static const Color textSecondaryDark = Color(0xFFA6A2BE);
  static const Color borderDark = Color(0xFF38364A);

  // --- Acento del ahorro (mismo violeta de marca) ---
  static const Color savings = Color(0xFF7C5CFF);
  static const Color savingsSurface = Color(0xFFEDE9FE);
}
