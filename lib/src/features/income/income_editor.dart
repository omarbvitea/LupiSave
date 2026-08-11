import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/format/money.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/shared/widgets/app_button.dart';
import 'package:app/src/shared/widgets/app_text_field.dart';
import 'package:app/src/shared/widgets/money_field.dart';
import 'package:app/src/features/income/income_providers.dart';

/// Abre el editor de ingreso (alta si [existing] es null, edición si no) como
/// hoja inferior modal. Devuelve `true` si se guardó.
Future<bool?> showIncomeEditor(BuildContext context, {Income? existing}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _IncomeEditorSheet(existing: existing),
  );
}

class _IncomeEditorSheet extends ConsumerStatefulWidget {
  const _IncomeEditorSheet({this.existing});

  final Income? existing;

  @override
  ConsumerState<_IncomeEditorSheet> createState() => _IncomeEditorSheetState();
}

class _IncomeEditorSheetState extends ConsumerState<_IncomeEditorSheet> {
  late final TextEditingController _source;
  late final TextEditingController _amount;

  bool get _isEdit => widget.existing != null;

  /// Guardar solo se habilita con fuente (≥1 car.) y monto > 0.
  bool get _isValid =>
      _source.text.trim().isNotEmpty &&
      (Money.tryParseToCents(_amount.text) ?? 0) > 0;

  @override
  void initState() {
    super.initState();
    _source = TextEditingController(text: widget.existing?.source ?? '');
    _amount = TextEditingController(
      text: widget.existing == null
          ? ''
          : (widget.existing!.amountCents / 100)
                .toStringAsFixed(2)
                .replaceAll('.', ','),
    );
    _source.addListener(() => setState(() {}));
    _amount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _source.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final source = _source.text.trim();
    final cents = Money.tryParseToCents(_amount.text);
    if (source.isEmpty || cents == null || cents <= 0) return;

    final repo = ref.read(incomeRepositoryProvider);
    if (_isEdit) {
      await repo.edit(
        id: widget.existing!.id,
        source: source,
        amountCents: cents,
      );
    } else {
      await repo.add(source: source, amountCents: cents);
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
            _isEdit ? 'Editar ingreso' : 'Nuevo ingreso',
            style: theme.textTheme.titleLarge,
          ),
          AppSpacing.gapLg,
          AppTextField(
            label: 'Fuente',
            controller: _source,
            hint: 'Ej. Sueldo',
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
