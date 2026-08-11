import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/format/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Datos reales del caso de prueba, en céntimos.
  const income = 337000; // S/ 3.370,00
  const fixed = 44970; // S/ 449,70
  const cuotasAgosto = 121317; // S/ 1.213,17 vigente en agosto

  group('computePeriodSummary — datos reales, sin gastos registrados', () {
    final s = computePeriodSummary(
      incomeCents: income,
      fixedCents: fixed,
      cuotasVigentesCents: cuotasAgosto,
      gastoMensualRegisteredCents: 0,
      entretenimientoRegisteredCents: 0,
    );

    test('ahorro apartado = 20% = S/ 674,00 (RN-04)', () {
      expect(s.savingsCents, 67400);
      expect(Money.formatCents(s.savingsCents), 'S/ 674,00');
    });

    test('presupuestos de sobres = 50% y 30% (RN-05)', () {
      expect(s.gastoMensual.budgetCents, 168500); // S/ 1.685,00
      expect(s.entretenimiento.budgetCents, 101100); // S/ 1.011,00
    });

    test('Gasto Mensual gastado = fijos + cuotas vigentes (RN-06/RN-08)', () {
      expect(s.gastoMensual.spentCents, 166287); // S/ 1.662,87
      expect(s.gastoMensual.availableCents, 2213); // S/ 22,13
    });

    test('Entretenimiento gastado en cero sin registros (RN-07)', () {
      expect(s.entretenimiento.spentCents, 0);
      expect(s.entretenimiento.availableCents, 101100);
      expect(s.entretenimiento.usage, 0);
    });
  });

  test('disponible negativo permitido y señalado (RN-09)', () {
    final s = computePeriodSummary(
      incomeCents: income,
      fixedCents: fixed,
      cuotasVigentesCents: cuotasAgosto,
      gastoMensualRegisteredCents: 100000, // empuja el sobre a negativo
      entretenimientoRegisteredCents: 0,
    );
    expect(s.gastoMensual.availableCents, lessThan(0));
    expect(s.gastoMensual.isOverspent, isTrue);
  });

  test('disponible actual con los 4 gastos de agosto = S/ 684,13 (RN-11)', () {
    // Los 4 gastos reales de agosto van a Entretenimiento: 349,00.
    final s = computePeriodSummary(
      incomeCents: income,
      fixedCents: fixed,
      cuotasVigentesCents: cuotasAgosto,
      gastoMensualRegisteredCents: 0,
      entretenimientoRegisteredCents: 34900,
    );
    expect(s.disponibleActualCents, 68413);
    expect(Money.formatCents(s.disponibleActualCents), 'S/ 684,13');
    expect(s.entretenimiento.spentCents, 34900); // S/ 349,00
    expect(s.entretenimiento.availableCents, 66200); // S/ 662,00
    // Cierre de mes (RN-16): remanente neto y aporte total.
    expect(s.netRemainderCents, 68413); // S/ 684,13
    expect(s.totalContributionCents, 135813); // S/ 1.358,13
  });

  test('uso por sobre = gastado/presupuesto; cero si presupuesto es cero '
      '(RN-10)', () {
    final s = computePeriodSummary(
      incomeCents: 0,
      fixedCents: 0,
      cuotasVigentesCents: 0,
      gastoMensualRegisteredCents: 0,
      entretenimientoRegisteredCents: 0,
    );
    expect(s.gastoMensual.usage, 0); // presupuesto 0 -> 0
  });

  test('BudgetConfig exige que los porcentajes sumen 100% (RN-12)', () {
    expect(
      () => BudgetConfig(
          gastoMensualPct: 50, entretenimientoPct: 30, ahorroPct: 10),
      throwsA(isA<AssertionError>()),
    );
  });
}
