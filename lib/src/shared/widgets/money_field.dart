import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';

/// Campo numérico de monto. Optimizado para el registro rápido de gasto
/// (RNF-02): teclado numérico, foco automático opcional, símbolo `S/` fijo y
/// cifra grande. Sólo admite dígitos y un separador decimal.
class MoneyField extends StatelessWidget {
  const MoneyField({
    super.key,
    this.controller,
    this.autofocus = false,
    this.label,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController? controller;
  final bool autofocus;
  final String? label;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: theme.textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xxs),
        ],
        TextField(
          controller: controller,
          autofocus: autofocus,
          onChanged: onChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.start,
          style: theme.textTheme.displayMedium,
          inputFormatters: [
            // Dígitos con hasta dos decimales, separador '.' o ','.
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          decoration: InputDecoration(
            // prefixIcon (no prefixText) para que "S/" se vea siempre, no solo
            // al enfocar el campo.
            prefixIcon: Padding(
              // left = mismo padding horizontal que el resto de inputs.
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.xs,
              ),
              child: Text(
                'S/',
                style: theme.textTheme.displayMedium
                    ?.copyWith(color: AppColors.primary),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            hintText: '0,00',
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
