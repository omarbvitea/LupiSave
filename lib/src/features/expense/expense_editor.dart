import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/format/money.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/shared/widgets/app_button.dart';
import 'package:app/src/shared/widgets/app_text_field.dart';
import 'package:app/src/shared/widgets/category_selector.dart';
import 'package:app/src/shared/widgets/date_picker_field.dart';
import 'package:app/src/shared/widgets/money_field.dart';
import 'package:app/src/features/expense/expense_providers.dart';

/// Abre el editor de gasto (P2, teclado numérico solo — RNF-02) como bottom
/// sheet modal si [existing] es null, o edición (Historial, P3) si no. Usa el
/// navegador raíz para cubrir el footer del shell. Devuelve `true` si se guardó.
Future<bool?> showExpenseEditor(BuildContext context, {Expense? existing}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (_) => _ExpenseEditorScreen(existing: existing),
  );
}

class _ExpenseEditorScreen extends ConsumerStatefulWidget {
  const _ExpenseEditorScreen({this.existing});

  final Expense? existing;

  @override
  ConsumerState<_ExpenseEditorScreen> createState() =>
      _ExpenseEditorScreenState();
}

class _ExpenseEditorScreenState extends ConsumerState<_ExpenseEditorScreen> {
  final _amount = TextEditingController();
  final _description = TextEditingController();
  // Por defecto "Gasto Mensual" (primera categoría); el usuario puede cambiarla.
  ExpenseCategory _category = ExpenseCategory.values.first;
  late DateTime _date;

  bool get _isEdit => widget.existing != null;

  /// El botón guardar solo se habilita con descripción (≥1 car.) y monto > 0.
  bool get _isValid =>
      (Money.tryParseToCents(_amount.text) ?? 0) > 0 &&
      _description.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _date = e?.date ?? DateTime.now();
    if (e != null) {
      _category = e.category;
      _amount.text = (e.amountCents / 100)
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      _description.text = e.description ?? '';
    }
    _amount.addListener(() => setState(() {}));
    _description.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    // No se registran gastos en meses pasados (RN-23): el picker parte del
    // primer día del mes en curso.
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(firstDate) ? firstDate : _date,
      firstDate: firstDate,
      lastDate: DateTime(2035, 12, 31),
      helpText: 'Fecha del gasto',
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final cents = Money.tryParseToCents(_amount.text);
    if (cents == null || cents <= 0) return;

    final repo = ref.read(expenseRepositoryProvider);
    final description = _description.text.trim().isEmpty
        ? null
        : _description.text.trim();
    if (_isEdit) {
      await repo.edit(
        id: widget.existing!.id,
        date: _date,
        category: _category,
        amountCents: cents,
        description: description,
      );
    } else {
      await repo.add(
        date: _date,
        category: _category,
        amountCents: cents,
        description: description,
      );
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // El teclado empuja el sheet hacia arriba; limitamos el alto a ~90% para no
    // tapar toda la pantalla y dejar ver que es un modal.
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    // La barra del sistema (3 botones) queda encima del botón Guardar si no la
    // reservamos; `padding.bottom` vale su alto y 0 con el teclado abierto.
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboard + safeBottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Manija de arrastre + título del sheet.
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              child: Text(
                _isEdit ? 'Editar gasto' : 'Nuevo gasto',
                style: theme.textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                children: [
                  Text('Categoría', style: theme.textTheme.labelMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  CategorySelector(
                    value: _category,
                    onChanged: (c) => setState(() => _category = c),
                  ),
                  AppSpacing.gapLg,
                  MoneyField(
                    label: 'Monto',
                    controller: _amount,
                    autofocus: !_isEdit, // en alta, el teclado aparece solo
                  ),
                  AppSpacing.gapLg,
                  AppTextField(
                    label: 'Descripción',
                    controller: _description,
                    hint: 'Ej. Gasolina',
                    maxLength: 60,
                  ),
                  AppSpacing.gapLg,
                  Text('Fecha del gasto', style: theme.textTheme.labelMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  DatePickerField(
                    text: '${_date.day} '
                        '${Period.fromDate(_date).monthName.toLowerCase()} '
                        '${_date.year}',
                    onTap: _pickDate,
                  ),
                  AppSpacing.gapLg,
                  // Botón pegado al campo de fecha.
                  AppPrimaryButton(
                    label: 'Guardar gasto',
                    onPressed: _isValid ? _save : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

