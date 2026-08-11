import 'package:drift/drift.dart';

import 'package:app/src/core/db/app_database.dart';

/// Acceso a las fuentes de ingreso. Las pantallas hablan con este repositorio,
/// no con la base de datos directamente.
///
/// Reutiliza la clase de fila generada por Drift, [Income], como modelo.
class IncomeRepository {
  IncomeRepository(this._db);

  final AppDatabase _db;

  /// Todas las fuentes, ordenadas alfabéticamente. Stream reactivo: cualquier
  /// alta/edición/baja re-emite y la UI se actualiza sola.
  Stream<List<Income>> watchAll() {
    return (_db.select(_db.incomes)
          ..orderBy([(t) => OrderingTerm(expression: t.source)]))
        .watch();
  }

  Future<int> add({required String source, required int amountCents}) {
    return _db.into(_db.incomes).insert(
          IncomesCompanion.insert(source: source, amountCents: amountCents),
        );
  }

  Future<void> edit({
    required int id,
    required String source,
    required int amountCents,
  }) {
    return (_db.update(_db.incomes)..where((t) => t.id.equals(id))).write(
      IncomesCompanion(
        source: Value(source),
        amountCents: Value(amountCents),
      ),
    );
  }

  /// Activa o desactiva sin eliminar (RF-07). Una fuente inactiva deja de sumar.
  Future<void> setActive({required int id, required bool active}) {
    return (_db.update(_db.incomes)..where((t) => t.id.equals(id)))
        .write(IncomesCompanion(active: Value(active)));
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.incomes)..where((t) => t.id.equals(id))).go();
  }
}
