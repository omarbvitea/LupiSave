import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/shared/widgets/app_card.dart';
import 'package:app/src/shared/widgets/hero_pattern_painter.dart';
import 'package:app/src/shared/widgets/money_text.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_screen.dart';
import 'package:app/src/features/installment/installment_providers.dart';
import 'package:app/src/features/installment/installment_screen.dart';

/// Hub de Gastos (vista de nivel tab, con footer). Dos accesos: gastos fijos
/// (P4) y cuotas temporales (P5). Cada uno abre su pantalla de gestión (alta,
/// edición y borrado) sobre el navegador raíz, cubriendo el footer.
class GastosScreen extends ConsumerWidget {
  const GastosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final fixedTotal = ref.watch(fixedExpenseTotalCentsProvider);
    final vigenteTotal = ref.watch(vigenteInstallmentTotalCentsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        // ponytail: Column + Spacer ancla la card de Lupi abajo del todo. Solo
        // dos cards + título: no desborda en pantallas normales. Si algún día
        // crece el contenido, pasar al patrón scroll (LayoutBuilder + minHeight).
        child: Padding(
          // 110 libra la barra flotante en gestos; en celulares con 3 botones hay
          // que sumar su alto (`viewPadding.bottom`) o tapa la card de Lupi.
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            110 + MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Gastos', style: theme.textTheme.titleLarge),
              AppSpacing.gapMd,
              _GastoCard(
                icon: Icons.receipt_long_outlined,
                title: 'Gastos fijos',
                caption: 'Recurrentes cada mes',
                totalCents: fixedTotal,
                onTap: () => _open(context, const FixedExpenseScreen()),
              ),
              AppSpacing.gapSm,
              _GastoCard(
                icon: Icons.event_repeat_outlined,
                title: 'Cuotas temporales',
                caption: 'Compromisos con fecha de fin',
                totalCents: vigenteTotal,
                onTap: () => _open(context, const InstallmentScreen()),
              ),
              const Spacer(),
              const _LupiTipCard(),
              AppSpacing.gapMd,
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _GastoCard extends StatelessWidget {
  const _GastoCard({
    required this.icon,
    required this.title,
    required this.caption,
    required this.totalCents,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String caption;
  final int totalCents;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          AppSpacing.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xxs),
                Text(caption, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          MoneyText.cents(totalCents, style: theme.textTheme.titleMedium),
          AppSpacing.gapXs,
          Icon(Icons.chevron_right, color: theme.textTheme.bodySmall?.color),
        ],
      ),
    );
  }
}

/// Tarjeta de ánimo con Lupi, en morado claro (accent suave). Misma idea que la
/// hero del dashboard, pero con Lupi anclada abajo-izquierda y sobresaliendo.
class _LupiTipCard extends StatelessWidget {
  const _LupiTipCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.brightness == Brightness.dark
        ? AppColors.accentDark
        : AppColors.accentLight;
    final ink = theme.colorScheme.onSurface;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Margen izquierdo ~ media imagen: el borde de la card corta a Lupi por
        // la mitad. El padding-left interno separa el texto de la imagen.
        Padding(
          padding: const EdgeInsets.only(left: 42),
          child: AppCard(
            color: accent,
            borderColor: accent,
            backgroundPainter: HeroBubblesPainter(color: ink),
            padding: const EdgeInsets.fromLTRB(
              56,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.gapXs,
                Text(
                  'Registra tus gastos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Llevar el control te acerca a tus metas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ink,
                  ),
                ),
                AppSpacing.gapXs,
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          // El alto controla cuánto sobresale Lupi por encima de la card.
          child: Image.asset(
            'assets/images/lupi_new_expense.webp',
            height: 130,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
