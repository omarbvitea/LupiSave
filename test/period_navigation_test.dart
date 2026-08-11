import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/budget/budget_providers.dart';
import 'package:app/src/features/dashboard/summary_screen.dart';
import 'package:app/src/features/installment/installment_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _seedCuotas(ProviderContainer c) async {
  final repo = c.read(installmentRepositoryProvider);
  await repo.add(
      concept: 'Monitor OLED',
      amountCents: 65370,
      start: DateTime(2026, 9),
      end: DateTime(2026, 11));
  await repo.add(
      concept: 'Baldo celular',
      amountCents: 44667,
      start: DateTime(2026, 8),
      end: DateTime(2026, 9));
  await repo.add(
      concept: 'Macbook',
      amountCents: 76650,
      start: DateTime(2026, 8),
      end: DateTime(2026, 12));
}

void main() {
  test('las cuotas vigentes se reevalúan al cambiar de periodo (RN-03)',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    final c = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(() => DateTime(2026, 8, 8)),
    ]);
    addTearDown(() async {
      c.dispose();
      await db.close();
    });

    await _seedCuotas(c);
    await c.read(installmentsProvider.future);
    final notifier = c.read(selectedPeriodProvider.notifier);

    // Agosto: Baldo + Macbook (Monitor aún futura).
    expect(c.read(vigenteInstallmentTotalCentsProvider), 121317);

    // Septiembre: entra Monitor OLED -> los tres vigentes.
    notifier.state = const Period(2026, 9);
    expect(c.read(vigenteInstallmentTotalCentsProvider), 186687);

    // Enero 2027: fuera de todos los rangos.
    notifier.state = const Period(2027, 1);
    expect(c.read(vigenteInstallmentTotalCentsProvider), 0);
  });

  testWidgets('el selector de mes de Resumen refleja el periodo (RF-03)',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Se evita Drift real en el widget-test (deja timers pendientes y
    // pumpAndSettle no termina): el selector solo depende del periodo, así que se
    // fijan resumen y método de ahorro constantes.
    final summary = computePeriodSummary(
      incomeCents: 0,
      fixedCents: 0,
      cuotasVigentesCents: 0,
      gastoMensualRegisteredCents: 0,
      entretenimientoRegisteredCents: 0,
    );

    final container = ProviderContainer(overrides: [
      clockProvider.overrideWithValue(() => DateTime(2026, 8, 8)),
      periodSummaryProvider.overrideWithValue(summary),
      budgetConfigProvider.overrideWithValue(const BudgetConfig.standard()),
    ]);
    addTearDown(container.dispose);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: SummaryScreen()),
    ));
    await tester.pumpAndSettle();

    // Arranca en el mes actual (RF-03) y el selector lo muestra.
    expect(container.read(selectedPeriodProvider), const Period(2026, 8));
    expect(find.text('Agosto 2026'), findsOneWidget);

    // Al cambiar el periodo, el selector se actualiza solo.
    container.read(selectedPeriodProvider.notifier).state =
        const Period(2026, 9);
    await tester.pumpAndSettle();
    expect(find.text('Septiembre 2026'), findsOneWidget);
  });
}
