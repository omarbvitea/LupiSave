import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/shared/widgets/app_card.dart';
import 'package:app/src/shared/widgets/money_text.dart';
import 'package:app/src/features/income/income_editor.dart';
import 'package:app/src/features/income/income_providers.dart';

/// Pantalla de Ingresos (P6). Lista de fuentes con total de las activas (RN-01),
/// y alta, edición, eliminación y activación/desactivación (RF-07).
class IncomeScreen extends ConsumerWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomesAsync = ref.watch(incomesProvider);
    final totalCents = ref.watch(incomeTotalCentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ingresos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showIncomeEditor(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        tooltip: 'Agregar ingreso',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _TotalBar(totalCents: totalCents),
      body: incomesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (incomes) {
          if (incomes.isEmpty) return const _EmptyState();
          return SlidableAutoCloseBehavior(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xxl,
              ),
              itemCount: incomes.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  _IncomeTile(income: incomes[index]),
            ),
          );
        },
      ),
    );
  }
}

class _IncomeTile extends ConsumerWidget {
  const _IncomeTile({required this.income});

  final Income income;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.read(incomeRepositoryProvider);
    final dim = !income.active;

    // Deslizar a la izquierda elimina directo, sin confirmación (RF-07).
    return Slidable(
      key: ValueKey(income.id),
      groupTag: 'incomes', // solo una card abierta a la vez
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        dismissible: DismissiblePane(
          onDismissed: () => repo.delete(income.id),
        ),
        children: [
          SlidableAction(
            onPressed: (_) => repo.delete(income.id),
            backgroundColor: AppColors.negative,
            foregroundColor: AppColors.onPrimary,
            icon: Icons.delete_outline,
            borderRadius: AppRadius.cardRadius,
          ),
        ],
      ),
      child: AppCard(
        onTap: () => showIncomeEditor(context, existing: income),
        child: Opacity(
          opacity: dim ? 0.55 : 1,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(income.source, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        MoneyText.cents(
                          income.amountCents,
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
                value: income.active,
                onChanged: (v) => repo.setActive(id: income.id, active: v),
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
            Text('Ingreso total', style: theme.textTheme.titleMedium),
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
              Icons.account_balance_wallet_outlined,
              size: 48,
              color: theme.textTheme.bodySmall?.color,
            ),
            AppSpacing.gapMd,
            Text(
              'Aún no tienes fuentes de ingreso',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapXs,
            Text(
              'Toca el botón + para registrar tu primer ingreso.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
