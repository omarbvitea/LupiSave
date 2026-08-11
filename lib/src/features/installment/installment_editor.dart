import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/format/money.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/shared/widgets/app_button.dart';
import 'package:app/src/shared/widgets/app_text_field.dart';
import 'package:app/src/shared/widgets/money_field.dart';
import 'package:app/src/features/installment/installment_providers.dart';

/// Abre el editor de cuota (alta si [existing] es null, edición si no) como
/// hoja inferior modal. Devuelve `true` si se guardó.
Future<bool?> showInstallmentEditor(
  BuildContext context, {
  Installment? existing,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _InstallmentEditorSheet(existing: existing),
  );
}

class _InstallmentEditorSheet extends ConsumerStatefulWidget {
  const _InstallmentEditorSheet({this.existing});

  final Installment? existing;

  @override
  ConsumerState<_InstallmentEditorSheet> createState() =>
      _InstallmentEditorSheetState();
}

class _InstallmentEditorSheetState
    extends ConsumerState<_InstallmentEditorSheet> {
  late final TextEditingController _concept;
  late final TextEditingController _amount;
  late DateTime _start;
  late DateTime _end;
  String? _dateError;

  bool get _isEdit => widget.existing != null;

  /// Guardar solo se habilita con concepto (≥1 car.) y monto > 0. Las fechas se
  /// validan al guardar (siempre tienen valor), mostrando [_dateError].
  bool get _isValid =>
      _concept.text.trim().isNotEmpty &&
      (Money.tryParseToCents(_amount.text) ?? 0) > 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _concept = TextEditingController(text: widget.existing?.concept ?? '');
    _amount = TextEditingController(
      text: widget.existing == null
          ? ''
          : (widget.existing!.amountCents / 100)
                .toStringAsFixed(2)
                .replaceAll('.', ','),
    );
    _start = widget.existing?.startDate ?? now;
    _end = widget.existing?.endDate ?? now;
    _concept.addListener(() => setState(() {}));
    _amount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _concept.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickMonth({required bool isStart}) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month);
    final current = isStart ? _start : _end;
    final picked = await showDatePicker(
      context: context,
      initialDate: current.isBefore(firstDate) ? firstDate : current,
      firstDate: firstDate,
      lastDate: DateTime(2035, 12),
      helpText: isStart ? 'Cuota desde' : 'Cuota hasta',
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
      } else {
        _end = picked;
      }
    });
  }

  Future<void> _save() async {
    final concept = _concept.text.trim();
    final cents = Money.tryParseToCents(_amount.text);
    if (concept.isEmpty || cents == null || cents <= 0) return;
    // La comparación es por mes (RN-03): el fin no puede ser un mes anterior al
    // inicio.
    final endBeforeStart =
        Period.fromDate(_end).compareTo(Period.fromDate(_start)) < 0;
    setState(() {
      _dateError = endBeforeStart
          ? 'El fin no puede ser anterior al inicio'
          : null;
    });
    if (_dateError != null) return;

    final repo = ref.read(installmentRepositoryProvider);
    if (_isEdit) {
      await repo.edit(
        id: widget.existing!.id,
        concept: concept,
        amountCents: cents,
        start: _start,
        end: _end,
      );
    } else {
      await repo.add(
        concept: concept,
        amountCents: cents,
        start: _start,
        end: _end,
      );
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
            _isEdit ? 'Editar cuota' : 'Nueva cuota',
            style: theme.textTheme.titleLarge,
          ),
          AppSpacing.gapLg,
          AppTextField(
            label: 'Concepto',
            controller: _concept,
            hint: 'Ej. Macbook',
            maxLength: 40,
          ),
          AppSpacing.gapMd,
          MoneyField(
            label: 'Cuota mensual',
            controller: _amount,
          ),
          AppSpacing.gapMd,
          _MonthPickerField(
            label: 'Desde',
            value: Period.fromDate(_start).label,
            onTap: () => _pickMonth(isStart: true),
          ),
          AppSpacing.gapMd,
          _MonthPickerField(
            label: 'Hasta',
            value: Period.fromDate(_end).label,
            onTap: () => _pickMonth(isStart: false),
          ),
          if (_dateError != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              _dateError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
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

/// Campo con etiqueta que abre el selector de mes nativo al tocarlo.
class _MonthPickerField extends StatelessWidget {
  const _MonthPickerField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: AppSpacing.xxs),
        InputDecorator(
          decoration: const InputDecoration(),
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: theme.textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(Icons.calendar_month_outlined, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
