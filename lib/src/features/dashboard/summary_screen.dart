import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/format/money.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/shared/widgets/date_picker_field.dart';
import 'package:app/src/shared/widgets/money_text.dart';
import 'package:app/src/features/budget/budget_providers.dart';

/// Vista Resumen (accesible desde "ver más" del dashboard). Desglosa el ingreso
/// del periodo en una dona de cuatro tajadas —Gasto mensual, Entretenimiento,
/// Ahorro y Sobrante— más un selector de mes estilo input-date.
///
/// Sin flecha de "atrás" a propósito: se vuelve con el gesto/botón del sistema.
class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = ref.watch(periodSummaryProvider);
    final config = ref.watch(budgetConfigProvider);

    // Las cuatro tajadas de la dona. Suman siempre el ingreso del periodo.
    final slices = <_Slice>[
      _Slice(
        label: 'Gasto mensual',
        color: AppColors.primary,
        cents: s.gastoMensual.spentCents,
        subtitle: '${Money.formatCents(s.gastoMensual.budgetCents)} asignado',
      ),
      _Slice(
        label: 'Entretenimiento',
        color: AppColors.primaryLight,
        cents: s.entretenimiento.spentCents,
        subtitle:
            '${Money.formatCents(s.entretenimiento.budgetCents)} asignado',
      ),
      _Slice(
        label: 'Ahorro',
        color: AppColors.positive,
        cents: s.savingsCents,
        subtitle: '${Money.formatCents(s.savingsCents)} asignado',
      ),
      _Slice(
        label: 'Sobrante',
        color: AppColors.highlight,
        cents: s.disponibleActualCents,
        subtitle: 'disponible para gastar',
      ),
    ];

    // El footer vive en el shell (AppShell); aquí solo el contenido, con padding
    // inferior para que no quede tapado por el footer flotante.
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
            Text('Resumen', style: theme.textTheme.titleLarge),
            AppSpacing.gapLg,
            const _MonthSelector(),
            AppSpacing.gapLg,
            Text('Distribución ${config.label}',
                style: theme.textTheme.titleSmall),
            AppSpacing.gapLg,
            Column(
              children: [
                _Donut(income: s.incomeCents, slices: slices),
                AppSpacing.gapLg,
                for (final slice in slices) ...[
                  _LegendRow(slice: slice),
                  if (slice != slices.last) AppSpacing.gapMd,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Datos de una tajada de la dona y su fila de leyenda.
class _Slice {
  const _Slice({
    required this.label,
    required this.color,
    required this.cents,
    required this.subtitle,
  });

  final String label;
  final Color color;
  final int cents;
  final String subtitle;
}

/// Selector de mes estilo input-date: etiqueta del mes a la izquierda e ícono de
/// calendario a la derecha. Al tocar abre el date picker nativo y normaliza la
/// fecha elegida a su mes.
class _MonthSelector extends ConsumerWidget {
  const _MonthSelector();

  Future<void> _pick(
    BuildContext context,
    WidgetRef ref,
    Period current,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current.firstDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // ponytail: se ignora el día; solo interesa el mes. Picker mensual propio
      // solo si elegir día resulta molesto.
      ref.read(selectedPeriodProvider.notifier).state = Period.fromDate(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(selectedPeriodProvider);
    return DatePickerField(
      text: period.label,
      onTap: () => _pick(context, ref, period),
    );
  }
}

/// Dona con las cuatro tajadas y el total del ingreso al centro.
class _Donut extends StatelessWidget {
  const _Donut({required this.income, required this.slices});

  final int income;
  final List<_Slice> slices;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _DonutPainter(
              income: income,
              slices: slices,
              track: theme.dividerColor,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total ingreso', style: theme.textTheme.bodySmall),
              AppSpacing.gapXs,
              MoneyText.cents(
                income,
                style: theme.textTheme.titleLarge,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.income,
    required this.slices,
    required this.track,
  });

  final int income;
  final List<_Slice> slices;
  final Color track;

  static const double _stroke = 20;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - _stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Círculo de fondo (track) siempre visible.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..color = track,
    );

    if (income <= 0) return;

    var start = -math.pi / 2; // arranca arriba (12 en punto)
    for (final slice in slices) {
      // Negativos (p. ej. sobregasto) no dibujan tajada; el valor real se ve en
      // la leyenda.
      final value = slice.cents <= 0 ? 0 : slice.cents;
      if (value == 0) continue;
      final sweep = (value / income) * 2 * math.pi;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _stroke
          ..color = slice.color,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.income != income || old.slices != slices || old.track != track;
}

/// Fila de leyenda: punto de color + título/subtítulo + monto.
class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.slice});

  final _Slice slice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: slice.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(slice.label, style: theme.textTheme.titleSmall),
              Text(slice.subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        MoneyText.cents(slice.cents, style: theme.textTheme.titleSmall),
      ],
    );
  }
}
