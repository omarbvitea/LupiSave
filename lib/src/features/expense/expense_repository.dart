import 'package:drift/drift.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/time/period.dart';

/// Acceso a los gastos registrados. Lectura por periodo (RN-07) y alta llegan
/// en la Etapa 5/7; edición y borrado, en la Etapa 8 (Historial).
///
/// Usa la clase de fila generada por Drift, [Expense], como modelo.
class ExpenseRepository {
  ExpenseRepository(this._db);

  final AppDatabase _db;

  /// Gastos cuya fecha cae dentro de [period] (RN-07), del más reciente al más
  /// antiguo. Stream reactivo.
  Stream<List<Expense>> watchForPeriod(Period period) {
    return (_db.select(_db.expenses)
          ..where((t) => t.date.isBetweenValues(period.firstDay, period.lastDay))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<int> add({
    required DateTime date,
    required ExpenseCategory category,
    required int amountCents,
    String? description,
  }) {
    return _db.into(_db.expenses).insert(
          ExpensesCompanion.insert(
            // Se normaliza al día (sin hora) para que el filtro por periodo sea
            // exacto en los bordes del mes.
            date: _dayOnly(date),
            category: category,
            amountCents: amountCents,
            description: Value(description),
          ),
        );
  }

  Future<void> edit({
    required int id,
    required DateTime date,
    required ExpenseCategory category,
    required int amountCents,
    String? description,
  }) {
    return (_db.update(_db.expenses)..where((t) => t.id.equals(id))).write(
      ExpensesCompanion(
        date: Value(_dayOnly(date)),
        category: Value(category),
        amountCents: Value(amountCents),
        description: Value(description),
      ),
    );
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.expenses)..where((t) => t.id.equals(id))).go();
  }

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
