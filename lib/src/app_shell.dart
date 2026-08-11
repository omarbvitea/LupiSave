import 'package:flutter/material.dart';

import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/features/dashboard/dashboard_screen.dart';
import 'package:app/src/features/expense/expense_editor.dart';
import 'package:app/src/features/expense/expenses_screen.dart';
import 'package:app/src/features/gastos/gastos_screen.dart';
import 'package:app/src/features/savings/savings_screen.dart';
import 'package:app/src/shared/widgets/app_bottom_nav.dart';

/// Cáscara de la app: el footer (barra inferior) vive aquí, a nivel de layout,
/// para que **siempre** esté visible y no aparezca/desaparezca al navegar.
///
/// El contenido se muestra dentro de un [Navigator] anidado: las vistas de nivel
/// tab (Dashboard, Resumen) navegan dentro del shell y quedan **debajo** del
/// footer; las sub-pantallas de detalle (Historial, Ahorro, etc.) se empujan en
/// el navegador raíz (`rootNavigator: true`) y cubren el footer.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _activeIndex = 0;

  /// Muestra una vista de nivel tab. Inicio siempre vuelve a la raíz (limpia
  /// cualquier detalle abierto, p. ej. Resumen). Para los demás tabs, si ya
  /// estás en ese tab no hace nada (no reanima); si no, la transición va **de la
  /// vista actual a la destino** en un solo movimiento con `pushAndRemoveUntil`
  /// (anima la nueva sobre la actual y recién después quita las intermedias, sin
  /// animación), así el back sigue volviendo a Inicio.
  void _selectTab(int index, Widget? screen) {
    final nav = _navigatorKey.currentState;
    if (nav == null) return;
    if (screen == null) {
      nav.popUntil((r) => r.isFirst);
      setState(() => _activeIndex = 0);
      return;
    }
    if (index == _activeIndex) return;
    nav.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => screen),
      (r) => r.isFirst,
    );
    setState(() => _activeIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // El back del sistema lo maneja el navegador anidado; si no hay nada que
      // desapilar (estamos en el dashboard) no hace nada.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final nav = _navigatorKey.currentState;
        if (nav != null && nav.canPop()) {
          nav.pop();
          setState(() => _activeIndex = 0);
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Navigator(
                key: _navigatorKey,
                onGenerateRoute: (_) => MaterialPageRoute<void>(
                  builder: (_) => const DashboardScreen(),
                ),
              ),
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                // Por encima de la barra de navegación del sistema: en celulares
                // con los 3 botones clásicos, `viewPadding.bottom` es su alto y
                // así el pill no queda tapado; con gestos ese inset es pequeño y
                // el pill se sienta cerca del borde igual que antes.
                bottom: MediaQuery.viewPaddingOf(context).bottom + AppSpacing.sm,
                child: AppBottomNav(
                  activeIndex: _activeIndex,
                  onInicio: () => _selectTab(0, null),
                  onGastos: () => _selectTab(1, const ExpensesScreen()),
                  onNuevo: () => showExpenseEditor(context),
                  onAhorros: () => _selectTab(3, const SavingsScreen()),
                  onGastosHub: () => _selectTab(2, const GastosScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
