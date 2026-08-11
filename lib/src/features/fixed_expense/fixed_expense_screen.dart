import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/shared/widgets/app_card.dart';
import 'package:app/src/shared/widgets/money_text.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_editor.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';

/// Pantalla de Gastos fijos (P4). Lista de conceptos con total de los activos
/// al pie (RN-02), y alta, edición, eliminación y activación/desactivación
/// (RF-05).
class FixedExpenseScreen extends ConsumerWidget {
  const FixedExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(fixedExpensesProvider);
    final totalCents = ref.watch(fixedExpenseTotalCentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gastos fijos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFixedExpenseEditor(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        tooltip: 'Agregar gasto fijo',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _TotalBar(totalCents: totalCents),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (expenses) {
          if (expenses.isEmpty) return const _EmptyState();
          return SlidableAutoCloseBehavior(
            child: ListView.separated(
              // Espacio inferior extra: el FAB flota sobre la lista y no debe
              // quedar montado encima de la última card.
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xxl * 2,
              ),
              itemCount: expenses.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  _FixedExpenseTile(expense: expenses[index]),
            ),
          );
        },
      ),
    );
  }
}

class _FixedExpenseTile extends ConsumerWidget {
  const _FixedExpenseTile({required this.expense});

  final FixedExpense expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.read(fixedExpenseRepositoryProvider);
    final dim = !expense.active;

    // Deslizar a la izquierda elimina directo, sin confirmación (RF-05).
    return Slidable(
      key: ValueKey(expense.id),
      groupTag: 'fixed_expenses', // solo una card abierta a la vez
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        dismissible: DismissiblePane(
          onDismissed: () => repo.delete(expense.id),
        ),
        children: [
          SlidableAction(
            onPressed: (_) => repo.delete(expense.id),
            backgroundColor: AppColors.negative,
            foregroundColor: AppColors.onPrimary,
            icon: Icons.delete_outline,
            borderRadius: AppRadius.cardRadius,
          ),
        ],
      ),
      child: AppCard(
        onTap: () => showFixedExpenseEditor(context, existing: expense),
        child: Opacity(
          opacity: dim ? 0.55 : 1,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expense.concept, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        MoneyText.cents(
                          expense.amountCents,
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (dim) ...[
                          AppSpacing.gapXs,
                          Text('· Inactivo', style: theme.textTheme.bodySmall),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Switch(
                value: expense.active,
                onChanged: (v) => repo.setActive(id: expense.id, active: v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalBar extends StatelessWidget {
  const _TotalBar({required this.totalCents});

  final int totalCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Gasto fijo mensual', style: theme.textTheme.titleMedium),
            MoneyText.cents(totalCents, style: theme.textTheme.headlineSmall),
          ],
        ),
      ),
    );
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: theme.textTheme.bodySmall?.color,
            ),
            AppSpacing.gapMd,
            Text(
              'Aún no tienes gastos fijos',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapXs,
            Text(
              'Toca el botón + para registrar tu primer gasto recurrente.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
