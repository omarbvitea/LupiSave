import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/budget/budget_config_repository.dart';
import 'package:app/src/features/expense/expense_providers.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';
import 'package:app/src/features/income/income_providers.dart';
import 'package:app/src/features/installment/installment_providers.dart';
import 'package:app/src/features/closure/month_close_service.dart';

final monthClosureRepositoryProvider =
    Provider<MonthClosureRepository>((ref) {
  return MonthClosureRepository(ref.watch(databaseProvider));
});

final monthCloseServiceProvider = Provider<MonthCloseService>((ref) {
  return MonthCloseService(
    db: ref.watch(databaseProvider),
    income: ref.watch(incomeRepositoryProvider),
    fixed: ref.watch(fixedExpenseRepositoryProvider),
    installments: ref.watch(installmentRepositoryProvider),
    expenses: ref.watch(expenseRepositoryProvider),
    closures: ref.watch(monthClosureRepositoryProvider),
    configs: ref.watch(budgetConfigRepositoryProvider),
  );
});

/// Cierres registrados, reactivo.
final closuresProvider = StreamProvider<List<MonthClosure>>((ref) {
  return ref.watch(monthClosureRepositoryProvider).watchAll();
});

/// Dispara el cierre automático de los meses terminados al arrancar la app
/// (una vez por lanzamiento, al ser un provider cacheado).
final monthCloseStartupProvider = FutureProvider<void>((ref) async {
  final current = ref.read(currentPeriodProvider);
  await ref.read(monthCloseServiceProvider).closeDuePeriods(current);
});
