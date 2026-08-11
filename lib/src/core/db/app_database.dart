import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:app/src/core/budget/budget.dart';

part 'app_database.g.dart';

/// Tabla llave-valor de propósito general.
///
/// Aloja configuración y metadatos simples de la app (periodo por defecto,
/// contador de aperturas, flags de primera apertura). Las tablas de negocio
/// (ingresos, gastos fijos, cuotas, gastos, cierres, retiros) se agregan en las
/// etapas siguientes sobre esta misma base de datos.
class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Fuentes de ingreso mensual (modelo de datos 3.1). El ingreso es fijo y
/// editable, no se captura por periodo (RN-20). El monto se guarda en céntimos
/// enteros (RNF-04).
class Incomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get source => text().withLength(min: 1, max: 40)();
  IntColumn get amountCents => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

/// Gastos fijos recurrentes sin fecha de término (modelo de datos 3.2). No
/// dependen del periodo (RN-02). El monto se guarda en céntimos enteros (RNF-04).
class FixedExpenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get concept => text().withLength(min: 1, max: 40)();
  IntColumn get amountCents => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

/// Cuotas temporales con fecha de inicio y fin (modelo de datos 3.3). Su
/// vigencia se calcula sola contra el periodo (RN-03/RN-13): no hay flag de
/// activo. Las fechas se guardan normalizadas al primer/último día de su mes.
/// El monto va en céntimos enteros (RNF-04).
class Installments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get concept => text().withLength(min: 1, max: 40)();
  IntColumn get amountCents => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
}

/// Gastos registrados manualmente por el usuario (modelo 3.4). La categoría es
/// una de dos ([ExpenseCategory]); nunca "Ahorro" (RN-15). La fecha se normaliza
/// al día (sin hora) para que el filtro por periodo (RN-07) sea exacto. El monto
/// va en céntimos enteros (RNF-04).
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get category => intEnum<ExpenseCategory>()();
  TextColumn get description => text().withLength(max: 60).nullable()();
  IntColumn get amountCents => integer()();
}

/// Cierre de mes (modelo 3.6). Un registro por periodo (la clave es única, lo
/// que garantiza idempotencia — RNF-10). Guarda los números del cierre como
/// snapshot (RN-20/RNF-11); el saldo acumulado resultante se deriva (RN-18) a
/// partir de la suma de aportes menos los retiros, no se persiste aquí.
class MonthClosures extends Table {
  TextColumn get periodKey => text()();
  IntColumn get savingsCents => integer()();
  IntColumn get netRemainderCents => integer()();
  IntColumn get totalContributionCents => integer()();
  DateTimeColumn get closedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {periodKey};
}

/// Método de ahorro (porcentajes 50/30/20…) vigente **a partir de** un periodo.
/// Efectivo-datado: la config de un mes es la fila con la mayor `periodKey` ≤ a
/// ese mes; si no hay ninguna anterior, se asume 50/30/20. Así, cambiar el
/// método solo rige del mes actual en adelante y los meses ya cerrados —que
/// guardan su ahorro como snapshot en [MonthClosures]— nunca se recalculan.
class SavingsMethods extends Table {
  TextColumn get periodKey => text()();
  IntColumn get gastoMensualPct => integer()();
  IntColumn get entretenimientoPct => integer()();
  IntColumn get ahorroPct => integer()();

  @override
  Set<Column> get primaryKey => {periodKey};
}

/// Base de datos local de la app (Drift sobre SQLite).
///
/// Es la única fuente de verdad persistente y funciona 100% sin conexión
/// (RNF-01). El dinero se guardará siempre en **céntimos enteros** (RNF-04).
@DriftDatabase(tables: [
  AppMeta,
  Incomes,
  FixedExpenses,
  Installments,
  Expenses,
  MonthClosures,
  SavingsMethods,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'vitenses'));

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v1 (sólo AppMeta) -> v2: se agrega la tabla de ingresos.
          if (from < 2) {
            await m.createTable(incomes);
          }
          // v2 -> v3: se agrega la tabla de gastos fijos.
          if (from < 3) {
            await m.createTable(fixedExpenses);
          }
          // v3 -> v4: se agrega la tabla de cuotas temporales.
          if (from < 4) {
            await m.createTable(installments);
          }
          // v4 -> v5: se agrega la tabla de gastos registrados.
          if (from < 5) {
            await m.createTable(expenses);
          }
          // v5 -> v6: se agrega la tabla de cierres de mes.
          if (from < 6) {
            await m.createTable(monthClosures);
          }
          // v7 -> v8: se agrega la tabla del método de ahorro por periodo.
          if (from < 8) {
            await m.createTable(savingsMethods);
          }
        },
      );

  // --- Acceso genérico a metadatos (llave-valor) ---------------------------

  /// Lee un valor de texto, o `null` si la llave no existe.
  Future<String?> readMeta(String key) async {
    final row = await (select(appMeta)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  /// Escribe (inserta o reemplaza) un valor de texto.
  Future<void> writeMeta(String key, String value) {
    return into(appMeta).insertOnConflictUpdate(
      AppMetaCompanion.insert(key: key, value: value),
    );
  }

  /// Stream reactivo de un valor entero. La UI que lo observe se actualiza sola
  /// cuando el valor cambia en la base de datos (patrón Drift → Riverpod → UI).
  Stream<int> watchIntMeta(String key) {
    return (select(appMeta)..where((t) => t.key.equals(key)))
        .watchSingleOrNull()
        .map((row) => int.tryParse(row?.value ?? '0') ?? 0);
  }

  /// Incrementa en uno un contador entero persistido y devuelve el nuevo valor.
  Future<int> incrementIntMeta(String key) async {
    final current = await readMeta(key);
    final next = (int.tryParse(current ?? '0') ?? 0) + 1;
    await writeMeta(key, next.toString());
    return next;
  }
}
