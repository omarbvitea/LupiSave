import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/expense/expense_providers.dart';
import 'package:app/src/features/expense/expenses_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Expense _e(int id, ExpenseCategory cat, int cents, int day, String? desc) =>
    Expense(
        id: id,
        date: DateTime(2026, 8, day),
        category: cat,
        amountCents: cents,
        description: desc);

Widget _host(List<Expense> expenses) {
  return ProviderScope(
    overrides: [
      selectedPeriodProvider.overrideWith((ref) => const Period(2026, 8)),
      expensesForSelectedPeriodProvider
          .overrideWith((ref) => Stream.value(expenses)),
    ],
    child: const MaterialApp(home: ExpensesScreen()),
  );
}

void main() {
  final expenses = [
    _e(1, ExpenseCategory.entretenimiento, 5000, 6, 'Gasolina'),
    _e(2, ExpenseCategory.entretenimiento, 27500, 6, 'Comida y ropa'),
    _e(3, ExpenseCategory.gastoMensual, 10000, 3, 'Recibo'),
  ];

  testWidgets('el total refleja la suma de los gastos visibles (RF-02)',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_host(expenses));
    await tester.pumpAndSettle();

    // Total de todos: 425,00.
    expect(find.text('S/ 425,00'), findsOneWidget);
    expect(find.text('Gasolina'), findsOneWidget);
    expect(find.text('Recibo'), findsOneWidget);

    // Filtra por Entretenimiento -> total 325,00 y desaparece "Recibo".
    await tester.tap(find.widgetWithText(ChoiceChip, 'Entretenimiento'));
    await tester.pumpAndSettle();
    expect(find.text('S/ 325,00'), findsOneWidget);
    expect(find.text('Recibo'), findsNothing);
  });

  testWidgets('la búsqueda filtra por descripción', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_host(expenses));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'gaso');
    await tester.pumpAndSettle();

    expect(find.text('Gasolina'), findsOneWidget);
    expect(find.text('Comida y ropa'), findsNothing);
    // S/ 50,00 aparece dos veces: total del filtro y el monto del único gasto.
    expect(find.text('S/ 50,00'), findsNWidgets(2));
  });

  testWidgets('tocar un gasto abre el editor en modo edición', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_host(expenses));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gasolina'));
    await tester.pumpAndSettle();

    expect(find.text('Editar gasto'), findsOneWidget);
  });
}
