import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/shared/widgets/app_card.dart';
import 'package:app/src/shared/widgets/app_progress_bar.dart';
import 'package:app/src/shared/widgets/hero_pattern_painter.dart';
import 'package:app/src/shared/widgets/money_text.dart';
import 'package:app/src/features/budget/budget_providers.dart';
import 'package:app/src/features/closure/closure_providers.dart';
import 'package:app/src/features/savings/savings_screen.dart';
import 'package:app/src/features/settings/config_screen.dart';
import 'package:app/src/features/dashboard/summary_screen.dart';

/// Pantalla principal (P1). Saludo + disponible hero, resumen del mes con los
/// dos sobres, ahorro apartado y una barra de navegación inferior.
///
/// La barra inferior es solo UI por ahora (sin navegación); las acciones reales
/// (registrar gasto, cambiar de mes, sub-pantallas) viven en el menú del
/// engranaje del encabezado.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(periodSummaryProvider);
    // Cierra automáticamente los meses terminados al abrir la app (Etapa 10).
    ref.watch(monthCloseStartupProvider);

    // El footer vive en el shell (AppShell); aquí solo el contenido, con padding
    // inferior para que la última card no quede tapada por el footer flotante.
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            110,
          ),
          children: [
            const _DashboardHeader(),
            AppSpacing.gapLg,
            _HeroAvailableCard(cents: s.disponibleActualCents),
            AppSpacing.gapLg,
            const _ResumenHeader(),
            AppSpacing.gapXs,
            _EnvelopeCard(title: 'Gasto Mensual', envelope: s.gastoMensual),
            AppSpacing.gapSm,
            _EnvelopeCard(
              title: 'Entretenimiento',
              envelope: s.entretenimiento,
            ),
            AppSpacing.gapLg,
            _SavingsCard(cents: s.savingsCents),
          ],
        ),
      ),
    );
  }
}

/// Encabezado de la pantalla: título + subtítulo a la izquierda y el engranaje
/// de configuración a la derecha.
class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu mes de un vistazo', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Esto es lo que llevas hasta hoy',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Configuración',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<void>(builder: (_) => const ConfigScreen()),
          ),
        ),
      ],
    );
  }
}

/// Tarjeta hero: disponible para gastar, violeta de marca con Lupi.
class _HeroAvailableCard extends StatelessWidget {
  const _HeroAvailableCard({required this.cents});

  final int cents;

  @override
  Widget build(BuildContext context) {
    // Stack sin recorte: la card violeta define el tamaño y Lupi se superpone
    // anclada al borde inferior, sobresaliendo por arriba (efecto "z-20").
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppCard(
          color: AppColors.primary,
          borderColor: AppColors.primary,
          backgroundPainter: const HeroPatternPainter(
            color: AppColors.onPrimary,
          ),
          // Reserva a la derecha el ancho de Lupi para que el monto no quede
          // debajo de ella.
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            120,
            AppSpacing.md,
          ),
          // Ancho completo: en un Stack la card se mediría al ancho del texto.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.gapSm,
              Text(
                'Disponible para gastar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onPrimary.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              MoneyText.cents(
                cents,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: AppSpacing.xs,
          bottom: 0,
          // El alto controla cuánto sobresale Lupi por encima de la card.
          child: Image.asset(
            'assets/images/lupi.webp',
            height: 130,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

/// Encabezado de la sección de sobres: título + enlace "ver más".
class _ResumenHeader extends StatelessWidget {
  const _ResumenHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Resumen del mes', style: theme.textTheme.titleSmall),
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const SummaryScreen()),
          ),
          child: Text(
            'ver más',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Tarjeta de un sobre: presupuesto, gastado, disponible y barra de uso.
class _EnvelopeCard extends StatelessWidget {
  const _EnvelopeCard({required this.title, required this.envelope});

  final String title;
  final EnvelopeSummary envelope;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Color por umbral de uso (RN-10): verde < 80%, ámbar hasta 100%, rojo si
    // se pasa.
    final Color barColor = envelope.usage < 0.8
        ? AppColors.positive
        : envelope.usage <= 1.0
        ? AppColors.warning
        : AppColors.negative;
    final usageLabel =
        '${(envelope.usage * 100).toStringAsFixed(1).replaceAll('.', ',')}%';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              Text(usageLabel, style: theme.textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(value: envelope.usage, color: barColor),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Metric(label: 'Presupuesto', cents: envelope.budgetCents),
              _Metric(label: 'Gastado', cents: envelope.spentCents),
              _Metric(
                label: 'Disponible',
                cents: envelope.availableCents,
                colorBySign: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.cents,
    this.colorBySign = false,
  });

  final String label;
  final int cents;
  final bool colorBySign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xxs),
        MoneyText.cents(
          cents,
          colorBySign: colorBySign,
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}

/// Tarjeta de ahorro: violeta desaturado, sin barra de uso porque el ahorro no
/// se consume (RN-15).
class _SavingsCard extends StatelessWidget {
  const _SavingsCard({required this.cents});

  final int cents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      color: AppColors.savingsSurface,
      borderColor: AppColors.savings,
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const SavingsScreen())),
      child: Row(
        children: [
          const Icon(Icons.savings_outlined, color: AppColors.savings),
          AppSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahorro Apartado',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.savings,
                  ),
                ),
                Text('20% del ingreso', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          MoneyText.cents(
            cents,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.savings,
            ),
          ),
        ],
      ),
    );
  }
}
