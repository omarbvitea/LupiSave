import 'package:flutter/material.dart';

import 'package:app/src/core/format/money.dart';
import 'package:app/src/core/theme/app_colors.dart';

/// Muestra un monto ya formateado como moneda peruana (RNF-04), con color
/// semántico opcional según el signo.
///
/// Es el componente que garantiza que NINGÚN monto se pinte "a mano": si en
/// algún momento cambia el formato o la moneda, se cambia sólo aquí.
class MoneyText extends StatelessWidget {
  const MoneyText.soles(
    this.soles, {
    super.key,
    this.style,
    this.colorBySign = false,
    this.fontWeight,
  }) : cents = null;

  const MoneyText.cents(
    this.cents, {
    super.key,
    this.style,
    this.colorBySign = false,
    this.fontWeight,
  }) : soles = null;

  /// Valor en soles (decimal). Excluyente con [cents].
  final num? soles;

  /// Valor en céntimos (entero). Excluyente con [soles].
  final int? cents;

  final TextStyle? style;

  /// Si es `true`, pinta el monto en verde cuando es ≥ 0 y en rojo cuando es
  /// negativo (útil para el Disponible Actual y los saldos de sobre).
  final bool colorBySign;

  /// Peso de la fuente. Si se da, sobreescribe el del [style] resuelto.
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final double value =
        soles?.toDouble() ?? Money.fromCents(cents ?? 0);
    final String text =
        soles != null ? Money.format(value) : Money.formatCents(cents ?? 0);

    Color? color;
    if (colorBySign) {
      color = value < 0 ? AppColors.negative : AppColors.positive;
    }

    final base = style ?? Theme.of(context).textTheme.titleMedium;
    return Text(
      text,
      style: base?.copyWith(color: color, fontWeight: fontWeight),
    );
  }
}
