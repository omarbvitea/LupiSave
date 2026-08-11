import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/shared/widgets/app_card.dart';
import 'package:app/src/shared/widgets/money_text.dart';
import 'package:app/src/features/expense/expense_editor.dart';
import 'package:app/src/features/expense/expense_providers.dart';

/// Vista de Gastos (P3, tab con footer). Historial del periodo agrupado por
/// fecha (más reciente arriba), con búsqueda por descripción, tags por categoría
/// y filtro por día. Tap en un gasto abre el editor (bottom sheet); deslizar a
/// la izquierda revela el ícono de eliminar (RF-02).
class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  String _query = '';
  ExpenseCategory? _filter; // null = todas
  DateTime? _day; // null = todo el periodo

  List<Expense> _visible(List<Expense> all) {
    final q = _query.trim().toLowerCase();
    return all.where((e) {
      if (_filter != null && e.category != _filter) return false;
      if (_day != null &&
          (e.date.year != _day!.year ||
              e.date.month != _day!.month ||
              e.date.day != _day!.day)) {
        return false;
      }
      if (q.isNotEmpty && !(e.description ?? '').toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _pickDay(Period period) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day ?? DateTime.now(),
      firstDate: period.firstDay,
      lastDate: period.lastDay,
      helpText: 'Filtrar por fecha',
    );
    if (picked != null) setState(() => _day = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final async = ref.watch(expensesForSelectedPeriodProvider);
    final period = ref.watch(selectedPeriodProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Historial', style: theme.textTheme.titleLarge),
                  Text(period.label, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            _Filters(
              filter: _filter,
              day: _day,
              onQuery: (v) => setState(() => _query = v),
              onFilter: (v) => setState(() => _filter = v),
              onPickDay: () => _pickDay(period),
              onClearDay: () => setState(() => _day = null),
            ),
            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (all) {
                  final visible = _visible(all);
                  return Column(
                    children: [
                      Expanded(
                        child: visible.isEmpty
                            ? const _EmptyState()
                            : _GroupedList(expenses: visible),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.filter,
    required this.day,
    required this.onQuery,
    required this.onFilter,
    required this.onPickDay,
    required this.onClearDay,
  });

  final ExpenseCategory? filter;
  final DateTime? day;
  final ValueChanged<String> onQuery;
  final ValueChanged<ExpenseCategory?> onFilter;
  final VoidCallback onPickDay;
  final VoidCallback onClearDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Column(
        children: [
          TextField(
            onChanged: onQuery,
            decoration: InputDecoration(
              hintText: 'Buscar por descripción',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Filtrar por fecha',
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: onPickDay,
              ),
            ),
          ),
          AppSpacing.gapSm,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Chip(
                  label: 'Todas',
                  selected: filter == null,
                  onTap: () => onFilter(null),
                ),
                for (final c in ExpenseCategory.values) ...[
                  AppSpacing.gapSm,
                  _Chip(
                    label: c.label,
                    selected: filter == c,
                    onTap: () => onFilter(c),
                  ),
                ],
                if (day != null) ...[
                  AppSpacing.gapSm,
                  InputChip(
                    label: Text(_dayChipLabel(day!)),
                    avatar: const Icon(Icons.event, size: 18),
                    onDeleted: onClearDay,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _dayChipLabel(DateTime d) =>
      '${d.day} ${Period.fromDate(d).monthName.toLowerCase().substring(0, 3)}';
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      // Solo bajamos el alto (densidad + tap-target), sin tocar color ni texto.
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// Lista con encabezados de fecha. Los gastos ya vienen ordenados por fecha
/// descendente desde el repositorio.
class _GroupedList extends StatelessWidget {
  const _GroupedList({required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final children = <Widget>[];
    DateTime? currentDay;
    for (final e in expenses) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      if (day != currentDay) {
        currentDay = day;
        children.add(
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xs,
            ),
            child: Text(_dayLabel(day), style: theme.textTheme.labelMedium),
          ),
        );
      }
      children.add(_ExpenseTile(expense: e));
      children.add(const SizedBox(height: AppSpacing.sm));
    }
    return SlidableAutoCloseBehavior(
      child: ListView(
        // Padding inferior generoso: el footer flotante del shell tapa el final.
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          110,
        ),
        children: children,
      ),
    );
  }

  static String _dayLabel(DateTime d) =>
      '${d.day} de ${Period.fromDate(d).monthName.toLowerCase()} ${d.year}';
}

class _ExpenseTile extends ConsumerWidget {
  const _ExpenseTile({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Los gastos de meses pasados son de solo lectura (RN-23): sin swipe de
    // borrar y el tap solo avisa.
    final locked = Period.fromDate(expense.date).isPast;
    // Swipe sobre la misma card: revela la acción roja de eliminar y, al
    // deslizar del todo, dispara el modal de confirmación (RF-02).
    return Slidable(
      key: ValueKey(expense.id),
      groupTag: 'expenses', // solo una card abierta a la vez
      endActionPane: locked
          ? null
          : ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.28,
              dismissible: DismissiblePane(
                confirmDismiss: () => _confirmDelete(context),
                onDismissed: () =>
                    ref.read(expenseRepositoryProvider).delete(expense.id),
              ),
              children: [
                SlidableAction(
                  onPressed: (_) async {
                    if (await _confirmDelete(context)) {
                      await ref
                          .read(expenseRepositoryProvider)
                          .delete(expense.id);
                    }
                  },
                  backgroundColor: AppColors.negative,
                  foregroundColor: AppColors.onPrimary,
                  icon: Icons.delete_outline,
                  borderRadius: AppRadius.cardRadius,
                ),
              ],
            ),
      child: AppCard(
        onTap: () => locked
            ? _notifyLocked(context)
            : showExpenseEditor(context, existing: expense),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description?.isNotEmpty == true
                        ? expense.description!
                        : expense.category.label,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    expense.category.label,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            MoneyText.cents(
              expense.amountCents,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _notifyLocked(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('No puedes editar gastos de meses anteriores.'),
        ),
      );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      // Usar el context del propio diálogo: con el context del tile se popea el
      // Navigator anidado del shell (te manda a inicio) y el diálogo queda vivo.
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar gasto'),
        content: const Text(
          '¿Eliminar este gasto? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.negative),
            ),
          ),
        ],
      ),
    );
    return ok ?? false;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'No hay gastos que coincidan.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
