import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/budget/budget_providers.dart';
import 'package:app/src/features/closure/closure_providers.dart';
import 'package:app/src/features/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(PeriodSummary summary) {
  return ProviderScope(
    overrides: [
      selectedPeriodProvider.overrideWith((ref) => const Period(2026, 8)),
      periodSummaryProvider.overrideWithValue(summary),
      // No dispares el cierre real (Drift) en el widget-test.
      monthCloseStartupProvider.overrideWith((ref) async {}),
    ],
    child: const MaterialApp(home: DashboardScreen()),
  );
}

void main() {
  testWidgets('muestra disponible, sobres, ahorro y resumen (datos reales)',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Agosto 2026 con datos reales y sin gastos registrados.
    final summary = computePeriodSummary(
      incomeCents: 337000,
      fixedCents: 44970,
      cuotasVigentesCents: 121317,
      gastoMensualRegisteredCents: 0,
      entretenimientoRegisteredCents: 0,
    );
    await tester.pumpWidget(_host(summary));
    await tester.pumpAndSettle();

    // Encabezado y hero.
    expect(find.text('Tu mes de un vistazo'), findsOneWidget);
    expect(find.text('Disponible para gastar'), findsOneWidget);
    expect(find.text('S/ 1.033,13'), findsOneWidget); // disponible actual
    // Sobres.
    expect(find.text('Gasto Mensual'), findsOneWidget);
    expect(find.text('Entretenimiento'), findsOneWidget);
    expect(find.text('S/ 1.685,00'), findsOneWidget); // presupuesto GM
    expect(find.text('S/ 1.662,87'), findsOneWidget); // gastado GM
    expect(find.text('S/ 22,13'), findsOneWidget); // disponible GM
    // Ahorro apartado.
    expect(find.text('Ahorro Apartado'), findsOneWidget);
    expect(find.text('S/ 674,00'), findsOneWidget);
  });

  testWidgets('el hero usa el violeta de marca aunque el disponible sea negativo',
      (tester) async {
    final summary = computePeriodSummary(
      incomeCents: 100000,
      fixedCents: 90000,
      cuotasVigentesCents: 90000, // fuerza disponible negativo
      gastoMensualRegisteredCents: 0,
      entretenimientoRegisteredCents: 0,
    );
    expect(summary.disponibleActualCents, lessThan(0));

    await tester.pumpWidget(_host(summary));
    await tester.pumpAndSettle();

    // El hero es siempre violeta (fiel a la maqueta), no cambia con el signo.
    final heroViolet = find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration as BoxDecoration).color == AppColors.primary);
    expect(heroViolet, findsWidgets);
  });
}
