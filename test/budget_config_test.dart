import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/features/budget/budget_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';

SavingsMethod _row(String key, BudgetConfig c) => SavingsMethod(
      periodKey: key,
      gastoMensualPct: c.gastoMensualPct,
      entretenimientoPct: c.entretenimientoPct,
      ahorroPct: c.ahorroPct,
    );

const _standard = BudgetConfig.standard(); // 50/30/20
const _agresivo =
    BudgetConfig(gastoMensualPct: 70, entretenimientoPct: 20, ahorroPct: 10);

void main() {
  test('sin filas => 50/30/20 por defecto', () {
    expect(configForPeriod(const [], const Period(2026, 8)), _standard);
  });

  test('toma la fila vigente más reciente <= al periodo', () {
    final rows = [_row('2026-08', _agresivo)];
    // Julio (antes del cambio) sigue en 50/30/20; agosto en adelante, 70/20/10.
    expect(configForPeriod(rows, const Period(2026, 7)), _standard);
    expect(configForPeriod(rows, const Period(2026, 8)), _agresivo);
    expect(configForPeriod(rows, const Period(2026, 9)), _agresivo);
  });

  test('un cambio no reescribe meses previos (efectivo-datado)', () {
    final rows = [
      _row('2026-06', _standard),
      _row('2026-08', _agresivo),
    ];
    expect(configForPeriod(rows, const Period(2026, 7)), _standard);
    expect(configForPeriod(rows, const Period(2026, 8)), _agresivo);
  });

  test('los presets suman 100 y son distinguibles por igualdad', () {
    for (final p in BudgetConfig.presets) {
      expect(p.gastoMensualPct + p.entretenimientoPct + p.ahorroPct, 100);
    }
    expect(BudgetConfig.presets.toSet(), hasLength(3));
    expect(_standard.label, '50/30/20');
  });
}
