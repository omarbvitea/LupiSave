import 'package:flutter/material.dart';

import 'package:app/src/core/theme/app_spacing.dart';

/// Campo de texto estándar (nombre de fuente, concepto, descripción, motivo).
/// Encapsula la etiqueta arriba + el input para que todos los formularios se
/// vean iguales.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.errorText,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: AppSpacing.xxs),
        TextField(
          controller: controller,
          maxLength: maxLength,
          textInputAction: textInputAction,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            counterText: '',
          ),
        ),
      ],
    );
  }
}
