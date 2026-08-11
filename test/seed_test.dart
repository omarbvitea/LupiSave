import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/features/expense/expense_providers.dart';
import 'package:app/src/features/expense/expense_repository.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_repository.dart';
import 'package:app/src/features/income/income_repository.dart';
import 'package:app/src/features/installment/installment_repository.dart';
import 'package:app/src/features/seed/initial_data_seeder.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late InitialDataSeeder seeder;
  late IncomeRepository income;
  late FixedExpenseRepository fixed;
  late InstallmentRepository installments;
  late ExpenseRepository expenses;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    income = IncomeRepository(db);
    fixed = FixedExpenseRepository(db);
    installments = InstallmentRepository(db);
    expenses = ExpenseRepository(db);
    seeder = InitialDataSeeder(
      income: income,
      fixed: fixed,
      installments: installments,
      expenses: expenses,
    );
  });
  tearDown(() => db.close());

  test(
    'carga ingresos, gastos fijos, cuotas y gastos de agosto (RF-14)',
    () async {
      expect(await seeder.loadIfEmpty(), isTrue);

      final ingresos = await income.watchAll().first;
      expect(ingresos.map((e) => e.source), ['Sueldo', 'Unicorp']);
      expect(ingresos.fold<int>(0, (s, i) => s + i.amountCents), 337000);

      final fijos = await fixed.watchAll().first;
      expect(fijos, hasLength(8));
      expect(fijos.fold<int>(0, (s, e) => s + e.amountCents), 44970);

      final cuotas = await installments.watchAll().first;
      expect(
        cuotas.map((c) => c.concept),
        containsAll(['Monitor OLED', 'Baldo celular', 'Macbook']),
      );

      // Los 4 gastos de agosto, todos en Entretenimiento (RN-21).
      final agosto = await expenses.watchForPeriod(const Period(2026, 8)).first;
      expect(agosto, hasLength(4));
      expect(
        agosto.every((e) => e.category == ExpenseCategory.entretenimiento),
        isTrue,
      );
      expect(
        registeredCentsFor(agosto, ExpenseCategory.entretenimiento),
        34900,
      );
    },
  );

  test('es idempotente: no vuelve a cargar si ya hay datos', () async {
    expect(await seeder.loadIfEmpty(), isTrue);
    expect(await seeder.loadIfEmpty(), isFalse); // segunda vez no hace nada

    expect(await income.watchAll().first, hasLength(2)); // sin duplicar
    expect(await fixed.watchAll().first, hasLength(8));
  });
}
