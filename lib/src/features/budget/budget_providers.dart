import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';
import 'package:app/src/features/income/income_providers.dart';
import 'package:app/src/features/installment/installment_providers.dart';
import 'package:app/src/features/expense/expense_providers.dart';
import 'package:app/src/features/budget/budget_config_repository.dart';

/// Método de ahorro vigente para el periodo **seleccionado** (RF-12). Se resuelve
/// del historial efectivo-datado; por defecto 50/30/20. Cambiarlo desde
/// Configuración solo afecta del mes actual en adelante (ver [configForPeriod]).
final budgetConfigProvider = Provider<BudgetConfig>((ref) {
  final rows = ref.watch(budgetConfigsProvider).valueOrNull ?? const [];
  final period = ref.watch(selectedPeriodProvider);
  return configForPeriod(rows, period);
});

/// Resumen calculado del periodo seleccionado (motor de la Etapa 5). Combina los
/// totales de ingresos, gastos fijos, cuotas vigentes y gastos registrados, y
/// se recalcula solo cuando cualquiera de ellos —o el periodo— cambia.
final periodSummaryProvider = Provider<PeriodSummary>((ref) {
  final expenses =
      ref.watch(expensesForSelectedPeriodProvider).valueOrNull ?? const [];
  return computePeriodSummary(
    incomeCents: ref.watch(incomeTotalCentsProvider),
    fixedCents: ref.watch(fixedExpenseTotalCentsProvider),
    cuotasVigentesCents: ref.watch(vigenteInstallmentTotalCentsProvider),
    gastoMensualRegisteredCents:
        registeredCentsFor(expenses, ExpenseCategory.gastoMensual),
    entretenimientoRegisteredCents:
        registeredCentsFor(expenses, ExpenseCategory.entretenimiento),
    config: ref.watch(budgetConfigProvider),
  );
});
