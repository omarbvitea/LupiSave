import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/budget/budget_providers.dart';
import 'package:app/src/features/dashboard/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('la vista Resumen muestra la leyenda y el ingreso total',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Caso de agosto 2026 (REQ §9): ingreso 3.370, sin gastos registrados.
    final summary = computePeriodSummary(
      incomeCents: 337000,
      fixedCents: 44970,
      cuotasVigentesCents: 121317,
      gastoMensualRegisteredCents: 0,
      entretenimientoRegisteredCents: 0,
    );

    await tester.pumpWidget(ProviderScope(
      overrides: [
        selectedPeriodProvider.overrideWith((ref) => const Period(2026, 8)),
        periodSummaryProvider.overrideWithValue(summary),
      ],
      child: const MaterialApp(home: SummaryScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Resumen'), findsOneWidget);
    expect(find.text('Agosto 2026'), findsOneWidget); // selector de mes
    expect(find.text('Total ingreso'), findsOneWidget);
    expect(find.text('S/ 3.370,00'), findsWidgets); // ingreso al centro
    // Las cuatro tajadas de la leyenda.
    expect(find.text('Gasto mensual'), findsOneWidget);
    expect(find.text('Entretenimiento'), findsOneWidget);
    expect(find.text('Ahorro'), findsOneWidget);
    expect(find.text('Sobrante'), findsOneWidget);
  });
}
