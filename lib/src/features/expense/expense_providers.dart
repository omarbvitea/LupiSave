import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/expense/expense_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(ref.watch(databaseProvider));
});

/// Gastos registrados del periodo seleccionado (RN-07). Reactivo y por periodo.
final expensesForSelectedPeriodProvider =
    StreamProvider<List<Expense>>((ref) {
  final period = ref.watch(selectedPeriodProvider);
  return ref.watch(expenseRepositoryProvider).watchForPeriod(period);
});

/// Total registrado del periodo, en céntimos, para una categoría.
int registeredCentsFor(List<Expense> expenses, ExpenseCategory category) =>
    expenses
        .where((e) => e.category == category)
        .fold<int>(0, (sum, e) => sum + e.amountCents);
