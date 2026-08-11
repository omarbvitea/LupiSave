import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/shared/widgets/app_card.dart';
import 'package:app/src/shared/widgets/money_text.dart';
import 'package:app/src/shared/widgets/status_chip.dart';
import 'package:app/src/features/installment/installment_editor.dart';
import 'package:app/src/features/installment/installment_providers.dart';
import 'package:app/src/features/installment/installment_status.dart';

/// Pantalla de Cuotas temporales (P5). Lista con estado (Vigente/Futura/
/// Finalizada) por cuota y total vigente del periodo al pie (RN-03), con alta,
/// edición y eliminación (RF-06).
class InstallmentScreen extends ConsumerWidget {
  const InstallmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installmentsAsync = ref.watch(installmentsProvider);
    final totalCents = ref.watch(vigenteInstallmentTotalCentsProvider);
    final period = ref.watch(selectedPeriodProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cuotas temporales')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showInstallmentEditor(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        tooltip: 'Agregar cuota',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _TotalBar(totalCents: totalCents, period: period),
      body: installmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (installments) {
          if (installments.isEmpty) return const _EmptyState();
          return SlidableAutoCloseBehavior(
            child: ListView.separated(
              // Espacio inferior extra: el FAB flota sobre la lista y no debe
              // quedar montado encima de la última card.
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xxl * 2),
              itemCount: installments.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  _InstallmentTile(installment: installments[index]),
            ),
          );
        },
      ),
    );
  }
}

class _InstallmentTile extends ConsumerWidget {
  const _InstallmentTile({required this.installment});

  final Installment installment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.read(installmentRepositoryProvider);
    final period = ref.watch(selectedPeriodProvider);
    final status = installmentStatus(installment, period);
    final dim = status == InstallmentStatus.finalizada;
    // Una cuota finalizada quedó en el pasado: es de solo lectura (RN-23).
    final locked = dim;

    // Deslizar a la izquierda elimina directo, sin confirmación (RF-06).
    return Slidable(
      key: ValueKey(installment.id),
      groupTag: 'installments', // solo una card abierta a la vez
      endActionPane: locked
          ? null
          : ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.28,
              dismissible: DismissiblePane(
                onDismissed: () => repo.delete(installment.id),
              ),
              children: [
                SlidableAction(
                  onPressed: (_) => repo.delete(installment.id),
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
            : showInstallmentEditor(context, existing: installment),
        child: Opacity(
          opacity: dim ? 0.6 : 1,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(installment.concept,
                              style: theme.textTheme.titleMedium),
                        ),
                        _StatusChip(status: status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    MoneyText.cents(installment.amountCents,
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${Period.fromDate(installment.startDate).label} — '
                      '${Period.fromDate(installment.endDate).label}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _notifyLocked(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('No puedes editar cuotas ya finalizadas.'),
        ),
      );
  }
}

/// Chip de estado con el color semántico de cada vigencia.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final InstallmentStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (Color color, Color surface) = switch (status) {
      InstallmentStatus.vigente => (
          AppColors.positive,
          AppColors.positiveSurface
        ),
      InstallmentStatus.futura => (AppColors.warning, AppColors.warningSurface),
      InstallmentStatus.finalizada => (
          theme.colorScheme.onSurfaceVariant,
          theme.colorScheme.surfaceContainerHighest
        ),
    };
    return StatusChip(label: status.label, color: color, surface: surface);
  }
}

class _TotalBar extends StatelessWidget {
  const _TotalBar({required this.totalCents, required this.period});

  final int totalCents;
  final Period period;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Vigente en ${period.label}',
                style: theme.textTheme.titleMedium),
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
            Icon(Icons.event_repeat_outlined,
                size: 48, color: theme.textTheme.bodySmall?.color),
            AppSpacing.gapMd,
            Text('Aún no tienes cuotas',
                style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            AppSpacing.gapXs,
            Text('Toca el botón + para registrar un compromiso con fecha de '
                'inicio y fin.',
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
