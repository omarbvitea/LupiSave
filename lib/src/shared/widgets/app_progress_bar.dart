import 'package:flutter/material.dart';

/// Barra de progreso del uso de un sobre (design system). El color lo decide
/// quien la usa (verde/ámbar/rojo según el umbral), para no acoplar el
/// componente a reglas de negocio.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 8,
  });

  /// Fracción usada. Se recorta a 0..1 para dibujar (un sobre sobregirado se
  /// muestra lleno; el número exacto se ve en la cifra, no en la barra).
  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
