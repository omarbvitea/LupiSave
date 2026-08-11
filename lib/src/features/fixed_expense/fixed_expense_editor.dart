import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/format/money.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/shared/widgets/app_button.dart';
import 'package:app/src/shared/widgets/app_text_field.dart';
import 'package:app/src/shared/widgets/money_field.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';

/// Abre el editor de gasto fijo (alta si [existing] es null, edición si no)
/// como hoja inferior modal. Devuelve `true` si se guardó.
Future<bool?> showFixedExpenseEditor(
  BuildContext context, {
  FixedExpense? existing,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _FixedExpenseEditorSheet(existing: existing),
  );
}

class _FixedExpenseEditorSheet extends ConsumerStatefulWidget {
  const _FixedExpenseEditorSheet({this.existing});

  final FixedExpense? existing;

  @override
  ConsumerState<_FixedExpenseEditorSheet> createState() =>
      _FixedExpenseEditorSheetState();
}

class _FixedExpenseEditorSheetState
    extends ConsumerState<_FixedExpenseEditorSheet> {
  late final TextEditingController _concept;
  late final TextEditingController _amount;

  bool get _isEdit => widget.existing != null;

  /// Guardar solo se habilita con concepto (≥1 car.) y monto > 0.
  bool get _isValid =>
      _concept.text.trim().isNotEmpty &&
      (Money.tryParseToCents(_amount.text) ?? 0) > 0;

  @override
  void initState() {
    super.initState();
    _concept = TextEditingController(text: widget.existing?.concept ?? '');
    _amount = TextEditingController(
      text: widget.existing == null
          ? ''
          : (widget.existing!.amountCents / 100)
                .toStringAsFixed(2)
                .replaceAll('.', ','),
    );
    _concept.addListener(() => setState(() {}));
    _amount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _concept.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final concept = _concept.text.trim();
    final cents = Money.tryParseToCents(_amount.text);
    if (concept.isEmpty || cents == null || cents <= 0) return;

    final repo = ref.read(fixedExpenseRepositoryProvider);
    if (_isEdit) {
      await repo.edit(
        id: widget.existing!.id,
        concept: concept,
        amountCents: cents,
      );
    } else {
      await repo.add(concept: concept, amountCents: cents);
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Padding que respeta el teclado abierto y la barra del sistema (en celulares
    // con 3 botones, `padding.bottom` es su alto; con teclado abierto vale 0).
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: AppSpacing.lg + bottomInset + safeBottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEdit ? 'Editar gasto fijo' : 'Nuevo gasto fijo',
            style: theme.textTheme.titleLarge,
          ),
          AppSpacing.gapLg,
          AppTextField(
            label: 'Concepto',
            controller: _concept,
            hint: 'Ej. Movistar',
            maxLength: 40,
          ),
          AppSpacing.gapMd,
          MoneyField(
            label: 'Monto mensual',
            controller: _amount,
          ),
          AppSpacing.gapLg,
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  label: 'Cancelar',
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              AppSpacing.gapSm,
              Expanded(
                child: AppPrimaryButton(
                  label: 'Guardar',
                  onPressed: _isValid ? _save : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
