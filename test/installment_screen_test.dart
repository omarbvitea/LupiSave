import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/installment/installment_providers.dart';
import 'package:app/src/features/installment/installment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({
  required List<Installment> installments,
  Period period = const Period(2026, 8),
}) {
  return ProviderScope(
    overrides: [
      installmentsProvider.overrideWith((ref) => Stream.value(installments)),
      selectedPeriodProvider.overrideWith((ref) => period),
    ],
    child: const MaterialApp(home: InstallmentScreen()),
  );
}

Installment _cuota(String concept, int cents, DateTime start, DateTime end) =>
    Installment(
        id: concept.hashCode,
        concept: concept,
        amountCents: cents,
        startDate: start,
        endDate: end);

void main() {
  testWidgets('Muestra estado por cuota y total vigente del periodo (RN-03)',
      (tester) async {
    await tester.pumpWidget(_host(installments: [
      // Vigente en agosto: Baldo + Macbook = S/ 1.213,17.
      _cuota('Baldo celular', 44667, DateTime(2026, 8), DateTime(2026, 9, 30)),
      _cuota('Macbook', 76650, DateTime(2026, 8), DateTime(2026, 12, 31)),
      // Futura en agosto.
      _cuota('Monitor OLED', 65370, DateTime(2026, 9), DateTime(2026, 11, 30)),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Vigente'), findsNWidgets(2));
    expect(find.text('Futura'), findsOneWidget);
    expect(find.text('S/ 1.213,17'), findsOneWidget); // total vigente
    expect(find.text('Vigente en Agosto 2026'), findsOneWidget);
  });

  testWidgets('El editor no deja guardar con fin anterior al inicio',
      (tester) async {
    // La hoja + el diálogo del selector no caben en el viewport por defecto.
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_host(installments: const []));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Concepto y monto válidos, para aislar el error de fechas.
    await tester.enterText(find.byType(TextField).first, 'Prueba');
    await tester.enterText(find.byType(TextField).last, '100');

    // Por defecto inicio = fin = hoy. Empujamos "Desde" tres meses adelante
    // con el selector nativo, dejando el inicio después del fin. El ícono de
    // calendario del primer campo (Desde) abre su selector.
    await tester.tap(find.byIcon(Icons.calendar_month_outlined).first);
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('El fin no puede ser anterior al inicio'), findsOneWidget);
  });
}
