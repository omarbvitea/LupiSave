import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/features/income/income_providers.dart';
import 'package:app/src/features/income/income_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required List<Income> incomes}) {
  return ProviderScope(
    overrides: [incomesProvider.overrideWith((ref) => Stream.value(incomes))],
    child: const MaterialApp(home: IncomeScreen()),
  );
}

void main() {
  testWidgets('Muestra las fuentes y el total de activos (RN-01)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        incomes: const [
          Income(id: 1, source: 'Sueldo', amountCents: 137000, active: true),
          Income(id: 2, source: 'Unicorp', amountCents: 200000, active: true),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sueldo'), findsOneWidget);
    expect(find.text('Unicorp'), findsOneWidget);
    expect(find.text('S/ 1.370,00'), findsOneWidget); // tile
    expect(find.text('S/ 2.000,00'), findsOneWidget); // tile
    expect(find.text('S/ 3.370,00'), findsOneWidget); // total activo
  });

  testWidgets('El editor deshabilita guardar sin fuente ni monto (> 0)', (
    tester,
  ) async {
    await tester.pumpWidget(_host(incomes: const []));
    await tester.pumpAndSettle();

    // Abre el editor con el FAB (solo ícono).
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    FilledButton guardar() =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Guardar'));

    // Vacío: deshabilitado.
    expect(guardar().onPressed, isNull);

    // Solo fuente: sigue deshabilitado (falta monto > 0).
    await tester.enterText(find.byType(TextField).first, 'Sueldo');
    await tester.pump();
    expect(guardar().onPressed, isNull);

    // Fuente + monto: habilitado.
    await tester.enterText(find.byType(TextField).last, '1200');
    await tester.pump();
    expect(guardar().onPressed, isNotNull);
  });
}
