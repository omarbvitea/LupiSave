import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required List<FixedExpense> expenses}) {
  return ProviderScope(
    overrides: [
      fixedExpensesProvider.overrideWith((ref) => Stream.value(expenses)),
    ],
    child: const MaterialApp(home: FixedExpenseScreen()),
  );
}

void main() {
  testWidgets('Muestra los conceptos y el total de activos (RN-02)',
      (tester) async {
    await tester.pumpWidget(_host(expenses: const [
      FixedExpense(id: 1, concept: 'Chatgpt', amountCents: 1990, active: true),
      FixedExpense(id: 2, concept: 'Cupo', amountCents: 20000, active: true),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Chatgpt'), findsOneWidget);
    expect(find.text('Cupo'), findsOneWidget);
    expect(find.text('S/ 19,90'), findsOneWidget); // tile
    expect(find.text('S/ 200,00'), findsOneWidget); // tile
    expect(find.text('S/ 219,90'), findsOneWidget); // total activo
  });

  testWidgets('El editor deshabilita guardar sin concepto ni monto (> 0)',
      (tester) async {
    await tester.pumpWidget(_host(expenses: const []));
    await tester.pumpAndSettle();

    // Abre el editor.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    FilledButton guardar() => tester
        .widget<FilledButton>(find.widgetWithText(FilledButton, 'Guardar'));

    // Vacío: deshabilitado.
    expect(guardar().onPressed, isNull);

    // Solo concepto: sigue deshabilitado (falta monto > 0).
    await tester.enterText(find.byType(TextField).first, 'Movistar');
    await tester.pump();
    expect(guardar().onPressed, isNull);

    // Concepto + monto: habilitado.
    await tester.enterText(find.byType(TextField).last, '80');
    await tester.pump();
    expect(guardar().onPressed, isNotNull);
  });
}
