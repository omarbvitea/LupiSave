/// Motor de cálculo del periodo (Etapa 5). Es Dart puro: sin Flutter, sin Drift
/// y sin dependencias de estado, para que sea determinista y fácil de probar.
/// Todo el dinero se maneja en **céntimos enteros** (RNF-04).
library;

/// Las dos categorías contra las que se registra un gasto (modelo 3.4). No
/// existe "Ahorro" (RN-15).
enum ExpenseCategory {
  gastoMensual('Gasto Mensual'),
  entretenimiento('Entretenimiento');

  const ExpenseCategory(this.label);

  final String label;
}

/// Porcentajes del método de ahorro (modelo 3.5). Deben sumar 100 (RN-12); el
/// constructor lo exige. Por defecto 50/30/20 ([BudgetConfig.standard]); el
/// usuario puede elegir otro método entre [presets] desde Configuración (RF-12).
class BudgetConfig {
  const BudgetConfig({
    required this.gastoMensualPct,
    required this.entretenimientoPct,
    required this.ahorroPct,
  }) : assert(gastoMensualPct + entretenimientoPct + ahorroPct == 100,
            'Los porcentajes deben sumar exactamente 100% (RN-12)');

  const BudgetConfig.standard()
      : gastoMensualPct = 50,
        entretenimientoPct = 30,
        ahorroPct = 20;

  final int gastoMensualPct;
  final int entretenimientoPct;
  final int ahorroPct;

  /// Etiqueta corta gasto/entretenimiento/ahorro, p. ej. `"50/30/20"`.
  String get label => '$gastoMensualPct/$entretenimientoPct/$ahorroPct';

  /// Métodos de ahorro permitidos por ahora. Todos suman 100 (RN-12).
  static const List<BudgetConfig> presets = [
    BudgetConfig.standard(),
    BudgetConfig(gastoMensualPct: 70, entretenimientoPct: 20, ahorroPct: 10),
    BudgetConfig(gastoMensualPct: 60, entretenimientoPct: 20, ahorroPct: 20),
  ];

  @override
  bool operator ==(Object other) =>
      other is BudgetConfig &&
      other.gastoMensualPct == gastoMensualPct &&
      other.entretenimientoPct == entretenimientoPct &&
      other.ahorroPct == ahorroPct;

  @override
  int get hashCode =>
      Object.hash(gastoMensualPct, entretenimientoPct, ahorroPct);
}

/// Cifras de un sobre de gasto en un periodo (RN-05, RN-08, RN-09, RN-10).
class EnvelopeSummary {
  const EnvelopeSummary({
    required this.budgetCents,
    required this.spentCents,
  });

  final int budgetCents;
  final int spentCents;

  /// Disponible = presupuesto − gastado. Puede ser negativo (RN-09): se señala,
  /// no se bloquea.
  int get availableCents => budgetCents - spentCents;

  bool get isOverspent => availableCents < 0;

  /// Uso = gastado / presupuesto. Si el presupuesto es cero, es cero (RN-10).
  double get usage => budgetCents == 0 ? 0 : spentCents / budgetCents;
}

/// Resultado completo del cálculo de un periodo.
class PeriodSummary {
  const PeriodSummary({
    required this.incomeCents,
    required this.fixedCents,
    required this.cuotasVigentesCents,
    required this.savingsCents,
    required this.gastoMensual,
    required this.entretenimiento,
    required this.registeredCents,
    required this.disponibleActualCents,
  });

  final int incomeCents;
  final int fixedCents;
  final int cuotasVigentesCents;

  /// Ahorro apartado del mes (RN-04).
  final int savingsCents;

  final EnvelopeSummary gastoMensual;
  final EnvelopeSummary entretenimiento;

  /// Suma de todos los gastos registrados del periodo (ambas categorías).
  final int registeredCents;

  /// Indicador principal (RN-11).
  final int disponibleActualCents;

  /// Remanente neto de los sobres al cerrar el mes (RN-16): suma algebraica de
  /// los disponibles de ambos sobres. Puede ser negativo (RN-17).
  int get netRemainderCents =>
      gastoMensual.availableCents + entretenimiento.availableCents;

  /// Aporte total del periodo al ahorro (RN-16): apartado + remanente neto.
  int get totalContributionCents => savingsCents + netRemainderCents;
}

int _pct(int cents, int pct) => (cents * pct / 100).round();

/// Calcula el resumen de un periodo a partir de sus totales ya agregados.
///
/// Recibe primitivos (no filas de base de datos) a propósito: el motor no sabe
/// de dónde salen los números, solo los combina según las reglas RN-04..RN-11.
PeriodSummary computePeriodSummary({
  required int incomeCents,
  required int fixedCents,
  required int cuotasVigentesCents,
  required int gastoMensualRegisteredCents,
  required int entretenimientoRegisteredCents,
  BudgetConfig config = const BudgetConfig.standard(),
}) {
  final savings = _pct(incomeCents, config.ahorroPct); // RN-04

  // RN-06: gastos fijos + cuotas vigentes se imputan íntegros a Gasto Mensual.
  // RN-07/RN-08: más los gastos registrados de cada categoría.
  final gastoMensual = EnvelopeSummary(
    budgetCents: _pct(incomeCents, config.gastoMensualPct), // RN-05
    spentCents:
        fixedCents + cuotasVigentesCents + gastoMensualRegisteredCents,
  );
  final entretenimiento = EnvelopeSummary(
    budgetCents: _pct(incomeCents, config.entretenimientoPct), // RN-05
    spentCents: entretenimientoRegisteredCents,
  );

  final registered =
      gastoMensualRegisteredCents + entretenimientoRegisteredCents;

  return PeriodSummary(
    incomeCents: incomeCents,
    fixedCents: fixedCents,
    cuotasVigentesCents: cuotasVigentesCents,
    savingsCents: savings,
    gastoMensual: gastoMensual,
    entretenimiento: entretenimiento,
    registeredCents: registered,
    // RN-11: ingreso − fijos − cuotas − ahorro − gastos registrados.
    disponibleActualCents: incomeCents -
        fixedCents -
        cuotasVigentesCents -
        savings -
        registered,
  );
}
