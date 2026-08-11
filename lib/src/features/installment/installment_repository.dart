import 'package:drift/drift.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/time/period.dart';

/// Acceso a las cuotas temporales. Normaliza las fechas al primer/último día de
/// su mes al guardar (modelo 3.3), reutilizando [Period], de modo que la
/// vigencia por mes (RN-03) siempre compare rangos completos.
///
/// Usa la clase de fila generada por Drift, [Installment], como modelo.
class InstallmentRepository {
  InstallmentRepository(this._db);

  final AppDatabase _db;

  /// Todas las cuotas, ordenadas por fecha de inicio y luego concepto.
  Stream<List<Installment>> watchAll() {
    return (_db.select(_db.installments)
          ..orderBy([
            (t) => OrderingTerm(expression: t.startDate),
            (t) => OrderingTerm(expression: t.concept),
          ]))
        .watch();
  }

  Future<int> add({
    required String concept,
    required int amountCents,
    required DateTime start,
    required DateTime end,
  }) {
    return _db.into(_db.installments).insert(
          InstallmentsCompanion.insert(
            concept: concept,
            amountCents: amountCents,
            startDate: Period.fromDate(start).firstDay,
            endDate: Period.fromDate(end).lastDay,
          ),
        );
  }

  Future<void> edit({
    required int id,
    required String concept,
    required int amountCents,
    required DateTime start,
    required DateTime end,
  }) {
    return (_db.update(_db.installments)..where((t) => t.id.equals(id))).write(
      InstallmentsCompanion(
        concept: Value(concept),
        amountCents: Value(amountCents),
        startDate: Value(Period.fromDate(start).firstDay),
        endDate: Value(Period.fromDate(end).lastDay),
      ),
    );
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.installments)..where((t) => t.id.equals(id))).go();
  }
}
