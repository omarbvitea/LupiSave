import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/budget/budget_providers.dart';
import 'package:app/src/features/expense/expense_providers.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';
import 'package:app/src/features/income/income_providers.dart';
import 'package:app/src/features/installment/installment_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _seedReales(ProviderContainer c) async {
  final income = c.read(incomeRepositoryProvider);
  await income.add(source: 'Sueldo', amountCents: 137000);
  await income.add(source: 'Unicorp', amountCents: 200000);

  final fixed = c.read(fixedExpenseRepositoryProvider);
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

  final cuotas = c.read(installmentRepositoryProvider);
  await cuotas.add(
    concept: 'Monitor OLED',
    amountCents: 65370,
    start: DateTime(2026, 9),
    end: DateTime(2026, 11),
  ); // futura en agosto
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

  final expenses = c.read(expenseRepositoryProvider);
  // Los 4 gastos reales de agosto, todos en Entretenimiento (349,00).
  for (final cents in [5000, 1500, 900, 27500]) {
    await expenses.add(
      date: DateTime(2026, 8, 3),
      category: ExpenseCategory.entretenimiento,
      amountCents: cents,
    );
  }
  // Un gasto de septiembre que NO debe contar en agosto (RN-07).
  await expenses.add(
    date: DateTime(2026, 9, 1),
    category: ExpenseCategory.entretenimiento,
    amountCents: 99900,
  );
}

Future<void> _settle(ProviderContainer c) async {
  await c.read(incomesProvider.future);
  await c.read(fixedExpensesProvider.future);
  await c.read(installmentsProvider.future);
  await c.read(expensesForSelectedPeriodProvider.future);
}

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        selectedPeriodProvider.overrideWith((ref) => const Period(2026, 8)),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test(
    'el resumen del periodo integra todas las fuentes (agosto 2026)',
    () async {
      await _seedReales(container);
      await _settle(container);

      final s = container.read(periodSummaryProvider);
      expect(s.incomeCents, 337000);
      expect(s.fixedCents, 44970);
      expect(s.cuotasVigentesCents, 121317); // Monitor OLED queda fuera
      expect(s.savingsCents, 67400);
      expect(s.gastoMensual.spentCents, 166287); // fijos + cuotas
      // El gasto de septiembre no cuenta en agosto (RN-07).
      expect(s.entretenimiento.spentCents, 34900); // S/ 349,00
      expect(s.entretenimiento.availableCents, 66200); // S/ 662,00
      expect(s.disponibleActualCents, 68413); // S/ 684,13
    },
  );

  test('historicidad: editar el ingreso no recalcula los gastos registrados '
      '(RN-14)', () async {
    await _seedReales(container);
    await _settle(container);
    expect(
      container.read(periodSummaryProvider).entretenimiento.spentCents,
      34900,
    );

    // Se agrega un ingreso nuevo (cambia el ingreso total del mes abierto).
    await container
        .read(incomeRepositoryProvider)
        .add(source: 'Extra', amountCents: 500000);
    await container.read(incomesProvider.future);

    // Los gastos ya registrados siguen intactos: no se recalculan.
    final expenses = await container.read(
      expensesForSelectedPeriodProvider.future,
    );
    expect(
      registeredCentsFor(expenses, ExpenseCategory.entretenimiento),
      34900,
    );
  });
}
