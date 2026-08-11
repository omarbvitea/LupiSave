import 'package:flutter/material.dart';

/// Escala tipográfica de la app.
///
/// Usa la familia por defecto de cada plataforma (San Francisco en iOS, Roboto
/// en Android) para verse nativa sin empaquetar fuentes. Lo que se fija aquí es
/// la ESCALA de tamaños/pesos, que es lo que da consistencia entre pantallas.
///
/// Roles relevantes para esta app:
/// - [displayLarge]  → la cifra destacada (Disponible Actual del dashboard).
/// - [headlineSmall] → montos destacados dentro de tarjetas.
/// - [titleMedium]   → títulos de sección / encabezados de tarjeta.
/// - [bodyLarge]/[bodyMedium] → texto general.
/// - [labelLarge]    → texto de botones y chips.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color primary, Color secondary) {
    return TextTheme(
      // Cifra protagonista (Disponible Actual)
      displayLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: primary,
      ),
      displayMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: primary,
      ),
      // Montos destacados dentro de tarjetas
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      // Títulos de sección / encabezado de tarjeta
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      // Cuerpo
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      // Botones y chips
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: secondary,
      ),
    );
  }
}
