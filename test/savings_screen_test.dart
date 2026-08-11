import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/features/budget/budget_providers.dart';
import 'package:app/src/features/savings/savings_providers.dart';
import 'package:app/src/features/savings/savings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra acumulado, apartado del mes y restante', (tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const summary = PeriodSummary(
      incomeCents: 480000,
      fixedCents: 0,
      cuotasVigentesCents: 0,
      savingsCents: 96000, // apartado del mes -> S/ 960,00
      gastoMensual: EnvelopeSummary(budgetCents: 32050, spentCents: 0),
      entretenimiento: EnvelopeSummary(budgetCents: 0, spentCents: 0),
      registeredCents: 0,
      disponibleActualCents: 0,
    ); // netRemainder = 32050 -> S/ 320,50

    await tester.pumpWidget(ProviderScope(
      overrides: [
        savingsBalanceCentsProvider.overrideWithValue(568000),
        periodSummaryProvider.overrideWithValue(summary),
      ],
      child: const MaterialApp(home: SavingsScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Ahorro acumulado'), findsOneWidget);
    expect(find.text('S/ 5.680,00'), findsOneWidget);
    expect(find.text('Ahorro apartado'), findsOneWidget);
    expect(find.text('S/ 960,00'), findsOneWidget);
    expect(find.text('Restante del mes'), findsOneWidget);
    expect(find.text('S/ 320,50'), findsOneWidget);
  });
}
