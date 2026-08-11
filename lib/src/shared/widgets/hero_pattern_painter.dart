import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Ondas suaves apiladas en diagonal para el fondo de los cards hero. Varias
/// líneas onduladas paralelas cruzan el card con desfase, dando sensación de
/// movimiento. Usa el color pasado (un token, p. ej. `onPrimary`/`onSurface`) a
/// baja opacidad, así se ve bien en cualquier tema.
class HeroPatternPainter extends CustomPainter {
  const HeroPatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.08);
    const amplitude = 10.0;
    final spacing = size.height / 3;
    for (var i = -1; i < 5; i++) {
      final baseY = i * spacing;
      final path = Path()..moveTo(0, baseY);
      for (var x = 0.0; x <= size.width; x += 6) {
        final t = x / size.width;
        final y = baseY + x * 0.35 + amplitude * math.sin(t * math.pi * 3);
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(HeroPatternPainter old) => old.color != color;
}

/// Arcos concéntricos para el fondo de cards hero: ondas que radian desde la
/// esquina inferior derecha, densas a la derecha y muy sueltas a la izquierda
/// para dejar libre el texto. Mismo criterio de color (token a baja opacidad)
/// que [HeroPatternPainter].
class HeroRipplePainter extends CustomPainter {
  const HeroRipplePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = color.withValues(alpha: 0.08);
    // Centro fuera de la esquina inferior derecha: los arcos se aprietan a la
    // derecha y solo los más grandes alcanzan la izquierda.
    final center = Offset(size.width * 1.02, size.height * 1.05);
    final maxR = size.width * 1.1;
    for (var r = 20.0; r < maxR; r += 85) {
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(HeroRipplePainter old) => old.color != color;
}

/// Burbujas sueltas para el fondo de cards hero: círculos de tamaños variados
/// repartidos por el card. Mismo criterio de color (token a baja opacidad) que
/// [HeroPatternPainter].
class HeroBubblesPainter extends CustomPainter {
  const HeroBubblesPainter({required this.color});

  final Color color;

  // Centro (fracción del tamaño) y radio en px de cada burbuja.
  static const _bubbles = <(double, double, double)>[
    (0.08, 0.24, 42),
    (0.40, 0.85, 26),
    (0.68, 0.20, 24),
    (1.00, 0.68, 48),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = color.withValues(alpha: 0.08);
    for (final (fx, fy, r) in _bubbles) {
      canvas.drawCircle(Offset(fx * size.width, fy * size.height), r, paint);
    }
  }

  @override
  bool shouldRepaint(HeroBubblesPainter old) => old.color != color;
}
