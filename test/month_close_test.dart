import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/meta_repository.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/features/budget/budget_config_repository.dart';
import 'package:app/src/features/closure/month_close_service.dart';
import 'package:app/src/features/expense/expense_repository.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_repository.dart';
import 'package:app/src/features/income/income_repository.dart';
import 'package:app/src/features/installment/installment_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

MonthCloseService _service(AppDatabase db) => MonthCloseService(
  db: db,
  income: IncomeRepository(db),
  fixed: FixedExpenseRepository(db),
  installments: InstallmentRepository(db),
  expenses: ExpenseRepository(db),
  closures: MonthClosureRepository(db),
  configs: BudgetConfigRepository(db),
);

Future<void> _seedAgosto(AppDatabase db) async {
  final income = IncomeRepository(db);
  await income.add(source: 'Sueldo', amountCents: 137000);
  await income.add(source: 'Unicorp', amountCents: 200000);

  final fixed = FixedExpenseRepository(db);
  for (final e in {
    'Chatgpt': 1990,
    'Icloud': 390,
    'YT Premium': 1000,
    'Claude': 8000,
    'Cupo': 20000,
    'Movistar': 3590,
    'Warda': 5000,
    'Win': 5000,
  }.entries) {
    await fixed.add(concept: e.key, amountCents: e.value);
  }

  final cuotas = InstallmentRepository(db);
  await cuotas.add(
    concept: 'Monitor OLED',
    amountCents: 65370,
    start: DateTime(2026, 9),
    end: DateTime(2026, 11),
  );
  await cuotas.add(
    concept: 'Baldo celular',
    amountCents: 44667,
    start: DateTime(2026, 8),
    end: DateTime(2026, 9),
  );
  await cuotas.add(
    concept: 'Macbook',
    amountCents: 76650,
    start: DateTime(2026, 8),
    end: DateTime(2026, 12),
  );

  final expenses = ExpenseRepository(db);
  for (final cents in [5000, 1500, 900, 27500]) {
    await expenses.add(
      date: DateTime(2026, 8, 3),
      category: ExpenseCategory.entretenimiento,
      amountCents: cents,
    );
  }
}

Future<int> _accumulated(AppDatabase db) async {
  final list = await MonthClosureRepository(db).watchAll().first;
  return list.fold<int>(0, (s, c) => s + c.totalContributionCents);
}

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test(
    'cierra agosto automáticamente al entrar en septiembre (RF-11/RN-16)',
    () async {
      await _seedAgosto(db);
      // El usuario venía usando agosto: el marcador está en agosto.
      await db.writeMeta(MetaKeys.openPeriod, const Period(2026, 8).key);

      await _service(db).closeDuePeriods(const Period(2026, 9));

      final closure = await MonthClosureRepository(
        db,
      ).getByPeriod(const Period(2026, 8).key);
      expect(closure, isNotNull);
      expect(closure!.savingsCents, 67400); // S/ 674,00
      expect(closure.netRemainderCents, 68413); // S/ 684,13
      expect(closure.totalContributionCents, 135813); // S/ 1.358,13
      // Primer cierre => acumulado = aporte total (RN-18).
      expect(await _accumulated(db), 135813);
      // El marcador avanzó a septiembre.
      expect(await db.readMeta(MetaKeys.openPeriod), const Period(2026, 9).key);
    },
  );

  test('idempotencia: cerrar dos veces no duplica (RNF-10)', () async {
    await _seedAgosto(db);
    await db.writeMeta(MetaKeys.openPeriod, const Period(2026, 8).key);
    final service = _service(db);

    await service.closeDuePeriods(const Period(2026, 9));
    // Segunda pasada + intento directo de cerrar agosto otra vez.
    await service.closeDuePeriods(const Period(2026, 9));
    expect(await service.close(const Period(2026, 8)), isFalse);

    final all = await MonthClosureRepository(db).watchAll().first;
    expect(all, hasLength(1));
    expect(await _accumulated(db), 135813); // no se duplicó
  });

  test(
    'los sobres del nuevo mes arrancan completos, sin arrastre (RN-16)',
    () async {
      await _seedAgosto(db);
      await db.writeMeta(MetaKeys.openPeriod, const Period(2026, 8).key);
      final service = _service(db);
      await service.closeDuePeriods(const Period(2026, 9));

      final sep = await service.summaryForPeriod(const Period(2026, 9));
      expect(sep.gastoMensual.budgetCents, 168500); // 50% completo
      expect(sep.entretenimiento.budgetCents, 101100); // 30% completo
    },
  );

  test(
    'cierra con el método vigente del mes; cambiarlo no toca lo cerrado',
    () async {
      await _seedAgosto(db);
      await db.writeMeta(MetaKeys.openPeriod, const Period(2026, 8).key);
      final configs = BudgetConfigRepository(db);

      // Agosto se cierra con 50/30/20 (sin método fijado): ahorro 20% = 67400.
      await _service(db).closeDuePeriods(const Period(2026, 9));
      final ago = await MonthClosureRepository(
        db,
      ).getByPeriod(const Period(2026, 8).key);
      expect(ago!.savingsCents, 67400);

      // A partir de septiembre el usuario cambia a 70/20/10 (ahorro 10%).
      await configs.setForPeriod(
        const Period(2026, 9).key,
        const BudgetConfig(
          gastoMensualPct: 70,
          entretenimientoPct: 20,
          ahorroPct: 10,
        ),
      );

      // El cierre de agosto no cambia (snapshot congelado).
      final agoOtraVez = await MonthClosureRepository(
        db,
      ).getByPeriod(const Period(2026, 8).key);
      expect(agoOtraVez!.savingsCents, 67400);

      // Septiembre se calcula con 10%: 337000 * 10% = 33700.
      final sep = await _service(db).summaryForPeriod(const Period(2026, 9));
      expect(sep.savingsCents, 33700);
    },
  );

  test('neto negativo se resta del ahorro acumulado (RN-17)', () async {
    // Ingreso chico y gasto fijo grande: los sobres quedan en negativo.
    await IncomeRepository(db).add(source: 'Sueldo', amountCents: 100000);
    await FixedExpenseRepository(db).add(concept: 'Renta', amountCents: 200000);
    await db.writeMeta(MetaKeys.openPeriod, const Period(2026, 8).key);

    await _service(db).closeDuePeriods(const Period(2026, 9));

    final closure = await MonthClosureRepository(
      db,
    ).getByPeriod(const Period(2026, 8).key);
    // GM: 50000 - 200000 = -150000 ; Ent: 30000 - 0 = 30000 ; neto = -120000.
    expect(closure!.netRemainderCents, -120000);
    // apartado 20000 + neto -120000 = -100000.
    expect(closure.totalContributionCents, -100000);
    expect(
      await _accumulated(db),
      -100000,
    ); // el acumulado baja (no se topa en 0)
  });
}
