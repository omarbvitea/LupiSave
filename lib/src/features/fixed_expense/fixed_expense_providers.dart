import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_repository.dart';

final fixedExpenseRepositoryProvider =
    Provider<FixedExpenseRepository>((ref) {
  return FixedExpenseRepository(ref.watch(databaseProvider));
});

/// Lista reactiva de todos los gastos fijos (activos e inactivos).
final fixedExpensesProvider = StreamProvider<List<FixedExpense>>((ref) {
  return ref.watch(fixedExpenseRepositoryProvider).watchAll();
});

/// Gastos fijos del mes en céntimos = suma de los gastos fijos **activos**
/// (RN-02). No depende del periodo.
final fixedExpenseTotalCentsProvider = Provider<int>((ref) {
  final expenses = ref.watch(fixedExpensesProvider).valueOrNull ?? const [];
  return expenses
      .where((e) => e.active)
      .fold<int>(0, (sum, e) => sum + e.amountCents);
});
