import 'package:drift/drift.dart';

import 'package:app/src/core/db/app_database.dart';

/// Acceso a los gastos fijos. Las pantallas hablan con este repositorio, no con
/// la base de datos directamente.
///
/// Reutiliza la clase de fila generada por Drift, [FixedExpense], como modelo.
class FixedExpenseRepository {
  FixedExpenseRepository(this._db);

  final AppDatabase _db;

  /// Todos los gastos fijos, ordenados alfabéticamente. Stream reactivo:
  /// cualquier alta/edición/baja re-emite y la UI se actualiza sola.
  Stream<List<FixedExpense>> watchAll() {
    return (_db.select(_db.fixedExpenses)
          ..orderBy([(t) => OrderingTerm(expression: t.concept)]))
        .watch();
  }

  Future<int> add({required String concept, required int amountCents}) {
    return _db.into(_db.fixedExpenses).insert(
          FixedExpensesCompanion.insert(
              concept: concept, amountCents: amountCents),
        );
  }

  Future<void> edit({
    required int id,
    required String concept,
    required int amountCents,
  }) {
    return (_db.update(_db.fixedExpenses)..where((t) => t.id.equals(id))).write(
      FixedExpensesCompanion(
        concept: Value(concept),
        amountCents: Value(amountCents),
      ),
    );
  }

  /// Activa o desactiva sin eliminar (RF-05). Un gasto inactivo deja de sumar.
  Future<void> setActive({required int id, required bool active}) {
    return (_db.update(_db.fixedExpenses)..where((t) => t.id.equals(id)))
        .write(FixedExpensesCompanion(active: Value(active)));
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.fixedExpenses)..where((t) => t.id.equals(id))).go();
  }
}
