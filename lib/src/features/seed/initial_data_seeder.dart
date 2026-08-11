import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/features/expense/expense_repository.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_repository.dart';
import 'package:app/src/features/income/income_repository.dart';
import 'package:app/src/features/installment/installment_repository.dart';

/// Carga de una sola vez el conjunto de datos reales del usuario (RF-14,
/// sección 8 de requerimientos): ingresos, gastos fijos, cuotas y los gastos de
/// agosto. Es idempotente: si ya hay ingresos, no vuelve a cargar nada.
class InitialDataSeeder {
  InitialDataSeeder({
    required IncomeRepository income,
    required FixedExpenseRepository fixed,
    required InstallmentRepository installments,
    required ExpenseRepository expenses,
  }) : _income = income,
       _fixed = fixed,
       _installments = installments,
       _expenses = expenses;

  // ignore_for_file: prefer_initializing_formals
  //
  // Params con nombre público (income) y campos privados (_income): la lista de
  // inicialización es correcta; el formal inicializador no aplica aquí.

  final IncomeRepository _income;
  final FixedExpenseRepository _fixed;
  final InstallmentRepository _installments;
  final ExpenseRepository _expenses;

  /// Carga los datos si aún no hay ninguno. Devuelve `true` si cargó.
  Future<bool> loadIfEmpty() async {
    if ((await _income.watchAll().first).isNotEmpty) return false;

    await _income.add(source: 'Metrica', amountCents: 137000);
    await _income.add(source: 'Unicorp', amountCents: 200000);

    const fijos = <String, int>{
      'Chatgpt': 1990,
      'Icloud': 390,
      'YT Premium': 1000,
      'Claude': 8000,
      'Cupo': 20000,
      'Movistar': 3590,
      'Warda': 5000,
      'Win': 5000,
    };
    for (final e in fijos.entries) {
      await _fixed.add(concept: e.key, amountCents: e.value);
    }

    await _installments.add(
      concept: 'Monitor OLED',
      amountCents: 65370,
      start: DateTime(2026, 9),
      end: DateTime(2026, 11),
    );
    await _installments.add(
      concept: 'Baldo celular',
      amountCents: 44667,
      start: DateTime(2026, 8),
      end: DateTime(2026, 9),
    );
    await _installments.add(
      concept: 'Macbook',
      amountCents: 76650,
      start: DateTime(2026, 8),
      end: DateTime(2026, 12),
    );

    // Los 4 gastos de agosto, todos en Entretenimiento (RN-21: se cargan tal
    // cual, sin reclasificar).
    const gastos = <(int, int, String)>[
      (5000, 1, 'Gasolina'),
      (1500, 1, 'Chifa CC'),
      (900, 3, 'Pichanga'),
      (27500, 6, 'Comida y ropa'),
    ];
    for (final (cents, day, desc) in gastos) {
      await _expenses.add(
        date: DateTime(2026, 8, day),
        category: ExpenseCategory.entretenimiento,
        amountCents: cents,
        description: desc,
      );
    }
    return true;
  }
}
