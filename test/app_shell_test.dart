import 'package:app/src/app_shell.dart';
import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/budget/budget_providers.dart';
import 'package:app/src/features/closure/closure_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el footer persiste al ir a Resumen y su botón Inicio vuelve',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
        monthCloseStartupProvider.overrideWith((ref) async {}),
      ],
      child: const MaterialApp(home: AppShell()),
    ));
    await tester.pumpAndSettle();

    // Arranca en el dashboard, con el footer visible.
    expect(find.text('Disponible para gastar'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);

    // "ver más" abre Resumen dentro del shell; el footer sigue presente.
    await tester.tap(find.text('ver más'));
    await tester.pumpAndSettle();
    expect(find.text('Resumen'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget); // el footer no desaparece

    // El botón Inicio del footer regresa al dashboard.
    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();
    expect(find.text('Resumen'), findsNothing);
    expect(find.text('Disponible para gastar'), findsOneWidget);
  });
}
