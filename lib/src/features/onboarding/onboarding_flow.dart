import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/meta_repository.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/shared/widgets/app_button.dart';
import 'package:app/src/shared/widgets/app_card.dart';
import 'package:app/src/shared/widgets/money_text.dart';
import 'package:app/src/features/budget/budget_config_repository.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_editor.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';
import 'package:app/src/features/income/income_editor.dart';
import 'package:app/src/features/income/income_providers.dart';
import 'package:app/src/features/installment/installment_editor.dart';
import 'package:app/src/features/installment/installment_providers.dart';

/// ¿El usuario ya terminó el onboarding? Gatea la pantalla raíz: mientras sea
/// false se muestra [OnboardingFlow]; al terminar se escribe el flag y se
/// invalida este provider para que la app rearme en el shell normal.
final onboardingDoneProvider = FutureProvider<bool>((ref) async {
  final v =
      await ref.watch(metaRepositoryProvider).readString(MetaKeys.onboardingDone);
  return v == '1';
});

/// Flujo de bienvenida + configuración inicial para usuarios nuevos. Bienvenida
/// (marca + Lupi + "Comenzar") y luego un asistente de 4 pasos: ingresos
/// (≥1 obligatorio), gastos fijos y cuotas (opcionales) y método de ahorro.
/// Los datos se guardan en vivo con los editores existentes; al finalizar solo
/// se fija el método y se marca el onboarding como hecho.
class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  int _step = 0; // 0 bienvenida · 1 ingresos · 2 fijos · 3 cuotas · 4 método
  BudgetConfig _method = const BudgetConfig.standard();

  void _next() => setState(() => _step++);
  void _back() => setState(() => _step--);

  Future<void> _finish() async {
    final period = ref.read(currentPeriodProvider);
    await ref
        .read(budgetConfigRepositoryProvider)
        .setForPeriod(period.key, _method);
    await ref
        .read(metaRepositoryProvider)
        .writeString(MetaKeys.onboardingDone, '1');
    ref.invalidate(onboardingDoneProvider); // → app.dart rearma en AppShell
  }

  @override
  Widget build(BuildContext context) {
    final step = switch (_step) {
      0 => _Welcome(onStart: _next),
      1 => _incomeStep(),
      2 => _fixedStep(),
      3 => _installmentStep(),
      _ => _methodStep(),
    };
    return Scaffold(
      body: SafeArea(
        // Transición suave entre pasos: el nuevo entra deslizando + fundido. La
        // key por paso es lo que le dice al switcher que cambió el contenido.
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: KeyedSubtree(key: ValueKey(_step), child: step),
        ),
      ),
    );
  }

  Widget _incomeStep() {
    final incomes = ref.watch(incomesProvider).valueOrNull ?? const [];
    return _StepScaffold(
      step: 1,
      title: 'Tus ingresos',
      subtitle:
          'Agrega al menos una fuente. Suma todo lo que recibes cada mes.',
      addLabel: 'Agregar ingreso',
      onAdd: () => showIncomeEditor(context),
      items: [
        for (final i in incomes)
          _ItemTile(
            title: i.source,
            cents: i.amountCents,
            onDelete: () => ref.read(incomeRepositoryProvider).delete(i.id),
          ),
      ],
      canNext: incomes.isNotEmpty,
      onNext: _next,
      onBack: _back,
    );
  }

  Widget _fixedStep() {
    final fixed = ref.watch(fixedExpensesProvider).valueOrNull ?? const [];
    return _StepScaffold(
      step: 2,
      title: 'Gastos fijos mensuales',
      subtitle: 'Suscripciones, servicios, alquiler. Puedes omitir este paso.',
      addLabel: 'Agregar gasto fijo',
      onAdd: () => showFixedExpenseEditor(context),
      items: [
        for (final f in fixed)
          _ItemTile(
            title: f.concept,
            cents: f.amountCents,
            onDelete: () =>
                ref.read(fixedExpenseRepositoryProvider).delete(f.id),
          ),
      ],
      canSkip: true,
      // Siguiente solo con ≥1 gasto fijo; Omitir descarta lo agregado (el paso
      // es opcional, pero si sigues, se guarda lo que registraste).
      canNext: fixed.isNotEmpty,
      onSkip: () async {
        final repo = ref.read(fixedExpenseRepositoryProvider);
        for (final f in fixed) {
          await repo.delete(f.id);
        }
        _next();
      },
      onNext: _next,
      onBack: _back,
    );
  }

  Widget _installmentStep() {
    final installments =
        ref.watch(installmentsProvider).valueOrNull ?? const [];
    return _StepScaffold(
      step: 3,
      title: 'Cuotas temporales',
      subtitle: 'Compras en cuotas con fecha de fin. Puedes omitir este paso.',
      addLabel: 'Agregar cuota',
      onAdd: () => showInstallmentEditor(context),
      items: [
        for (final c in installments)
          _ItemTile(
            title: c.concept,
            cents: c.amountCents,
            onDelete: () =>
                ref.read(installmentRepositoryProvider).delete(c.id),
          ),
      ],
      canSkip: true,
      // Igual que gastos fijos: Siguiente solo con ≥1 cuota; Omitir descarta.
      canNext: installments.isNotEmpty,
      onSkip: () async {
        final repo = ref.read(installmentRepositoryProvider);
        for (final c in installments) {
          await repo.delete(c.id);
        }
        _next();
      },
      onNext: _next,
      onBack: _back,
    );
  }

  Widget _methodStep() {
    return _StepScaffold(
      step: 4,
      title: 'Método de ahorro',
      subtitle:
          'Elige cómo repartir tu ingreso entre gasto, entretenimiento y ahorro.',
      items: [
        for (final preset in BudgetConfig.presets)
          _MethodTile(
            config: preset,
            selected: preset == _method,
            onTap: () => setState(() => _method = preset),
          ),
      ],
      nextLabel: 'Finalizar',
      canNext: true,
      onNext: _finish,
      onBack: _back,
    );
  }
}

/// Pantalla de bienvenida: marca arriba, Lupi al centro y "Comenzar" abajo.
class _Welcome extends StatelessWidget {
  const _Welcome({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Lupi', style: theme.textTheme.displayLarge),
                TextSpan(
                  text: 'Save',
                  style: theme.textTheme.displayLarge
                      ?.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/lupi_new_expense.webp',
                width: 220,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            'Organiza tus ingresos y gastos, con Lupi como guía.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          AppSpacing.gapLg,
          AppPrimaryButton(label: 'Comenzar', onPressed: onStart),
        ],
      ),
    );
  }
}

/// Armazón común de un paso del asistente: progreso, título, lista de ítems
/// con botón para agregar, y la fila de acciones (Atrás · Omitir · Siguiente).
class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.canNext,
    required this.onNext,
    required this.onBack,
    this.onAdd,
    this.addLabel,
    this.canSkip = false,
    this.onSkip,
    this.nextLabel = 'Siguiente',
  });

  final int step; // 1..4
  final String title;
  final String subtitle;
  final List<Widget> items;
  final VoidCallback? onAdd;
  final String? addLabel;
  final bool canSkip;
  final VoidCallback? onSkip;
  final bool canNext;
  final String nextLabel;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              AppSpacing.gapSm,
              Text('Paso $step de 4', style: theme.textTheme.labelMedium),
            ],
          ),
          AppSpacing.gapLg,
          Text(title, style: theme.textTheme.titleLarge),
          AppSpacing.gapXs,
          Text(subtitle, style: theme.textTheme.bodyMedium),
          AppSpacing.gapLg,
          Expanded(
            child: ListView(
              children: [
                ...items,
                if (items.isNotEmpty) AppSpacing.gapSm,
                if (onAdd != null)
                  AppSecondaryButton(
                    label: addLabel ?? 'Agregar',
                    icon: Icons.add,
                    onPressed: onAdd,
                  ),
              ],
            ),
          ),
          AppSpacing.gapMd,
          Row(
            children: [
              if (canSkip) ...[
                Expanded(
                  child: AppSecondaryButton(
                    label: 'Omitir',
                    onPressed: onSkip ?? onNext,
                  ),
                ),
                AppSpacing.gapSm,
              ],
              Expanded(
                child: AppPrimaryButton(
                  label: nextLabel,
                  onPressed: canNext ? onNext : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Ítem ya agregado (ingreso/gasto/cuota): concepto, monto y borrar.
class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.title,
    required this.cents,
    required this.onDelete,
  });

  final String title;
  final int cents;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  MoneyText.cents(cents, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: AppColors.negative,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}

/// Opción de método de ahorro con su desglose y check si está seleccionada.
class _MethodTile extends StatelessWidget {
  const _MethodTile({
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
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
              color:
                  selected ? AppColors.primary : theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}
