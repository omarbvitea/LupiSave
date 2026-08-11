import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/features/expense/expense_providers.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';
import 'package:app/src/features/income/income_providers.dart';
import 'package:app/src/features/installment/installment_providers.dart';
import 'package:app/src/features/seed/initial_data_seeder.dart';

final initialDataSeederProvider = Provider<InitialDataSeeder>((ref) {
  return InitialDataSeeder(
    income: ref.watch(incomeRepositoryProvider),
    fixed: ref.watch(fixedExpenseRepositoryProvider),
    installments: ref.watch(installmentRepositoryProvider),
    expenses: ref.watch(expenseRepositoryProvider),
  );
});
