import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/shared/widgets/app_card.dart';
import 'package:app/src/features/budget/budget_config_repository.dart';
import 'package:app/src/features/income/income_screen.dart';

/// Pantalla de Configuración. Se abre sobre el navegador raíz, así que cubre el
/// footer (no muestra el bottom nav). Permite editar ingresos y elegir el
/// método de ahorro (RF-07/RF-12).
class ConfigScreen extends ConsumerWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rows = ref.watch(budgetConfigsProvider).valueOrNull ?? const [];
    // El método se aplica del mes actual en adelante; los meses ya cerrados
    // conservan su ahorro y no se recalculan.
    final current = ref.watch(currentPeriodProvider);
    final active = configForPeriod(rows, current);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Configuración'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Ingresos', style: theme.textTheme.titleSmall),
          AppSpacing.gapSm,
          AppCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const IncomeScreen()),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    color: AppColors.primary),
                AppSpacing.gapMd,
                Expanded(
                  child: Text('Editar ingresos',
                      style: theme.textTheme.titleMedium),
                ),
                Icon(Icons.chevron_right,
                    color: theme.textTheme.bodySmall?.color),
              ],
            ),
          ),
          AppSpacing.gapLg,
          Text('Método de ahorro', style: theme.textTheme.titleSmall),
          AppSpacing.gapXs,
          Text(
            'Rige desde ${current.label} en adelante. Los meses cerrados no '
            'cambian.',
            style: theme.textTheme.bodySmall,
          ),
          AppSpacing.gapSm,
          for (final preset in BudgetConfig.presets) ...[
            _MethodOption(
              config: preset,
              selected: preset == active,
              onTap: () => ref
                  .read(budgetConfigRepositoryProvider)
                  .setForPeriod(current.key, preset),
            ),
            AppSpacing.gapSm,
          ],
        ],
      ),
    );
  }
}

/// Opción de método de ahorro: proporción, desglose y check si está activa.
class _MethodOption extends StatelessWidget {
  const _MethodOption({
    required this.config,
    required this.selected,
    required this.onTap,
  });

  final BudgetConfig config;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      borderColor: selected ? AppColors.primary : null,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(config.label, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Gasto ${config.gastoMensualPct}% · '
                  'Entretenimiento ${config.entretenimientoPct}% · '
                  'Ahorro ${config.ahorroPct}%',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            color: selected
                ? AppColors.primary
                : theme.textTheme.bodySmall?.color,
          ),
        ],
      ),
    );
  }
}
