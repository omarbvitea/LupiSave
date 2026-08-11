import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';
import 'package:app/src/features/income/income_repository.dart';

final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  return IncomeRepository(ref.watch(databaseProvider));
});

/// Lista reactiva de todas las fuentes de ingreso (activas e inactivas).
final incomesProvider = StreamProvider<List<Income>>((ref) {
  return ref.watch(incomeRepositoryProvider).watchAll();
});

/// Ingreso mensual total en céntimos = suma de las fuentes **activas** (RN-01).
final incomeTotalCentsProvider = Provider<int>((ref) {
  final incomes = ref.watch(incomesProvider).valueOrNull ?? const [];
  return incomes
      .where((i) => i.active)
      .fold<int>(0, (sum, i) => sum + i.amountCents);
});
