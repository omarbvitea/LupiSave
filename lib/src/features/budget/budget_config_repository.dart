import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';
import 'package:app/src/core/time/period.dart';

/// Persistencia del método de ahorro efectivo-datado (tabla [SavingsMethods]).
/// Cambiar el método escribe/actualiza la fila del periodo desde el que rige;
/// la config de cada mes se resuelve con [configForPeriod].
class BudgetConfigRepository {
  BudgetConfigRepository(this._db);

  final AppDatabase _db;

  Stream<List<SavingsMethod>> watchAll() {
    return (_db.select(_db.savingsMethods)
          ..orderBy([(t) => OrderingTerm(expression: t.periodKey)]))
        .watch();
  }

  Future<List<SavingsMethod>> getAll() {
    return (_db.select(_db.savingsMethods)
          ..orderBy([(t) => OrderingTerm(expression: t.periodKey)]))
        .get();
  }

  /// Fija el método vigente **desde** [periodKey] en adelante (upsert por clave).
  Future<void> setForPeriod(String periodKey, BudgetConfig config) {
    return _db.into(_db.savingsMethods).insertOnConflictUpdate(
          SavingsMethodsCompanion.insert(
            periodKey: periodKey,
            gastoMensualPct: config.gastoMensualPct,
            entretenimientoPct: config.entretenimientoPct,
            ahorroPct: config.ahorroPct,
          ),
        );
  }
}

/// Config vigente para [period]: la fila con la mayor `periodKey` ≤ `period.key`
/// (las claves `"YYYY-MM"` ordenan cronológicamente). Si no hay ninguna fila
/// anterior o igual, 50/30/20. Esto garantiza que un cambio no afecte meses
/// previos y que cada mes se cierre con el método vigente a su fin.
BudgetConfig configForPeriod(List<SavingsMethod> rows, Period period) {
  SavingsMethod? best;
  for (final r in rows) {
    if (r.periodKey.compareTo(period.key) > 0) continue;
    if (best == null || r.periodKey.compareTo(best.periodKey) > 0) best = r;
  }
  if (best == null) return const BudgetConfig.standard();
  return BudgetConfig(
    gastoMensualPct: best.gastoMensualPct,
    entretenimientoPct: best.entretenimientoPct,
    ahorroPct: best.ahorroPct,
  );
}

final budgetConfigRepositoryProvider = Provider<BudgetConfigRepository>((ref) {
  return BudgetConfigRepository(ref.watch(databaseProvider));
});

/// Historial reactivo de métodos de ahorro (filas efectivo-datadas).
final budgetConfigsProvider = StreamProvider<List<SavingsMethod>>((ref) {
  return ref.watch(budgetConfigRepositoryProvider).watchAll();
});
