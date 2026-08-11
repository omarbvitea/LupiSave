import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/expense/expense_editor.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(AppDatabase db) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      selectedPeriodProvider.overrideWith((ref) => const Period(2026, 8)),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showExpenseEditor(context),
            child: const Text('abrir'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  testWidgets('registra un gasto: monto + categoría se guardan (RF-01)',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_host(db));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '349');
    await tester.enterText(find.byType(TextField).last, 'Cine');
    await tester.tap(find.text('Entretenimiento'));
    await tester.pump();
    await tester.tap(find.text('Guardar gasto'));
    await tester.pumpAndSettle();

    final rows = await db.select(db.expenses).get();
    expect(rows, hasLength(1));
    expect(rows.single.amountCents, 34900);
    expect(rows.single.category, ExpenseCategory.entretenimiento);
  });

  testWidgets('guardar deshabilitado sin monto/descripción; usa categoría por '
      'defecto', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_host(db));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    // Sin monto ni descripción, el botón está deshabilitado: nada se guarda.
    await tester.tap(find.text('Guardar gasto'));
    await tester.pumpAndSettle();
    expect(await db.select(db.expenses).get(), isEmpty);

    // Con monto + descripción y sin tocar categoría, guarda con "Gasto Mensual"
    // por defecto.
    await tester.enterText(find.byType(TextField).first, '50');
    await tester.enterText(find.byType(TextField).last, 'Varios');
    await tester.pump();
    await tester.tap(find.text('Guardar gasto'));
    await tester.pumpAndSettle();

    final rows = await db.select(db.expenses).get();
    expect(rows, hasLength(1));
    expect(rows.single.category, ExpenseCategory.values.first);
  });
}
