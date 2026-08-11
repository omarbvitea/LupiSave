import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/features/closure/closure_providers.dart';
import 'package:app/src/features/savings/savings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

MonthClosure _closure(String key, int contribution) => MonthClosure(
      periodKey: key,
      savingsCents: 67400,
      netRemainderCents: contribution - 67400,
      totalContributionCents: contribution,
      closedAt: DateTime(2026, 9),
    );

Future<int> _balance({required List<MonthClosure> closures}) async {
  final c = ProviderContainer(overrides: [
    closuresProvider.overrideWith((ref) => Stream.value(closures)),
  ]);
  addTearDown(c.dispose);
  await c.read(closuresProvider.future);
  return c.read(savingsBalanceCentsProvider);
}

void main() {
  test('la categoría "Ahorro" no existe al registrar un gasto (RN-15)', () {
    expect(ExpenseCategory.values, hasLength(2));
    expect(ExpenseCategory.values.map((e) => e.label),
        isNot(contains('Ahorro')));
  });

  test('saldo = suma de aportes de los cierres (RN-18)', () async {
    final saldo = await _balance(
      closures: [_closure('2026-08', 135813)],
    );
    expect(saldo, 135813);
  });
}
