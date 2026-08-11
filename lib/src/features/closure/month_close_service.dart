import 'package:drift/drift.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/meta_repository.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/features/budget/budget_config_repository.dart';
import 'package:app/src/features/expense/expense_providers.dart';
import 'package:app/src/features/expense/expense_repository.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_repository.dart';
import 'package:app/src/features/income/income_repository.dart';
import 'package:app/src/features/installment/installment_repository.dart';
import 'package:app/src/features/installment/installment_status.dart';

/// Acceso a los cierres de mes. La clave de periodo es única, así que reinsertar
/// el mismo mes se ignora (idempotencia, RNF-10).
class MonthClosureRepository {
  MonthClosureRepository(this._db);

  final AppDatabase _db;

  Stream<List<MonthClosure>> watchAll() {
    return (_db.select(_db.monthClosures)
          ..orderBy([(t) => OrderingTerm(expression: t.periodKey)]))
        .watch();
  }

  Future<MonthClosure?> getByPeriod(String key) {
    return (_db.select(_db.monthClosures)..where((t) => t.periodKey.equals(key)))
        .getSingleOrNull();
  }

  Future<void> insertIfAbsent(MonthClosuresCompanion closure) {
    return _db
        .into(_db.monthClosures)
        .insert(closure, mode: InsertMode.insertOrIgnore);
  }
}

/// Cierra los meses terminados de forma automática (RF-11, RN-16..RN-18).
///
/// No tiene pantalla propia (eso es la Etapa 11): expone la lógica que el
/// arranque de la app dispara y que las pruebas verifican sobre los datos.
class MonthCloseService {
  MonthCloseService({
    required AppDatabase db,
    required IncomeRepository income,
    required FixedExpenseRepository fixed,
    required InstallmentRepository installments,
    required ExpenseRepository expenses,
    required MonthClosureRepository closures,
    required BudgetConfigRepository configs,
  })  : _db = db,
        _income = income,
        _fixed = fixed,
        _installments = installments,
        _expenses = expenses,
        _closures = closures,
        _configs = configs;

  // ignore_for_file: prefer_initializing_formals
  final AppDatabase _db;
  final IncomeRepository _income;
  final FixedExpenseRepository _fixed;
  final InstallmentRepository _installments;
  final ExpenseRepository _expenses;
  final MonthClosureRepository _closures;
  final BudgetConfigRepository _configs;

  /// Resumen de un periodo concreto (no del seleccionado), leyendo los datos
  /// vigentes en el momento del cierre.
  Future<PeriodSummary> summaryForPeriod(Period period) async {
    final incomeCents = (await _income.watchAll().first)
        .where((i) => i.active)
        .fold<int>(0, (s, i) => s + i.amountCents);
    final fixedCents = (await _fixed.watchAll().first)
        .where((e) => e.active)
        .fold<int>(0, (s, e) => s + e.amountCents);
    final cuotasCents = (await _installments.watchAll().first)
        .where((c) => installmentStatus(c, period) == InstallmentStatus.vigente)
        .fold<int>(0, (s, c) => s + c.amountCents);
    final exps = await _expenses.watchForPeriod(period).first;
    // El mes se cierra con el método de ahorro vigente a su fin (RN-12/RN-20).
    final config = configForPeriod(await _configs.getAll(), period);

    return computePeriodSummary(
      incomeCents: incomeCents,
      fixedCents: fixedCents,
      cuotasVigentesCents: cuotasCents,
      gastoMensualRegisteredCents:
          registeredCentsFor(exps, ExpenseCategory.gastoMensual),
      entretenimientoRegisteredCents:
          registeredCentsFor(exps, ExpenseCategory.entretenimiento),
      config: config,
    );
  }

  /// Cierra un periodo si no estaba cerrado. Devuelve `true` si generó el cierre.
  Future<bool> close(Period period) async {
    if (await _closures.getByPeriod(period.key) != null) return false;
    final s = await summaryForPeriod(period);
    await _closures.insertIfAbsent(MonthClosuresCompanion.insert(
      periodKey: period.key,
      savingsCents: s.savingsCents,
      netRemainderCents: s.netRemainderCents,
      totalContributionCents: s.totalContributionCents,
      closedAt: DateTime.now(),
    ));
    return true;
  }

  /// Cierra automáticamente todos los meses entre el último cerrado y el mes
  /// [current] (exclusivo). En la primera apertura solo fija el marcador.
  Future<void> closeDuePeriods(Period current) async {
    final openKey = await _db.readMeta(MetaKeys.openPeriod);
    if (openKey == null) {
      await _db.writeMeta(MetaKeys.openPeriod, current.key);
      return;
    }
    final open = Period.parse(openKey);
    if (current.compareTo(open) <= 0) return;

    var p = open;
    while (p.compareTo(current) < 0) {
      await close(p);
      p = p.next;
    }
    await _db.writeMeta(MetaKeys.openPeriod, current.key);
  }
}
