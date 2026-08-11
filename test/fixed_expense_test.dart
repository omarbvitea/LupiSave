import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/format/money.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_providers.dart';
import 'package:app/src/features/fixed_expense/fixed_expense_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

int _activeTotal(List<FixedExpense> list) =>
    list.where((e) => e.active).fold<int>(0, (s, e) => s + e.amountCents);

void main() {
  group('FixedExpenseRepository — CRUD y desactivación (RF-05)', () {
    late AppDatabase db;
    late FixedExpenseRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = FixedExpenseRepository(db);
    });
    tearDown(() => db.close());

    test('alta, orden alfabético y total de activos (RN-02)', () async {
      await repo.add(concept: 'Movistar', amountCents: 3590);
      await repo.add(concept: 'Chatgpt', amountCents: 1990);

      final list = await repo.watchAll().first;
      expect(list.map((e) => e.concept), ['Chatgpt', 'Movistar']); // ordenado
      expect(_activeTotal(list), 5580);
    });

    test('los 8 gastos fijos reales suman S/ 449,70', () async {
      const reales = <String, int>{
        'Chatgpt': 1990,
        'Icloud': 390,
        'YT Premium': 1000,
        'Claude': 8000,
        'Cupo': 20000,
        'Movistar': 3590,
        'Warda': 5000,
        'Win': 5000,
      };
      for (final e in reales.entries) {
        await repo.add(concept: e.key, amountCents: e.value);
      }

      final list = await repo.watchAll().first;
      expect(list.length, 8);
      expect(_activeTotal(list), 44970);
      expect(Money.formatCents(_activeTotal(list)), 'S/ 449,70');
    });

    test('desactivar excluye del total sin eliminar', () async {
      await repo.add(concept: 'Movistar', amountCents: 3590);
      await repo.add(concept: 'Cupo', amountCents: 20000);
      var list = await repo.watchAll().first;
      final cupo = list.firstWhere((e) => e.concept == 'Cupo');

      await repo.setActive(id: cupo.id, active: false);
      list = await repo.watchAll().first;

      expect(list.length, 2); // sigue existiendo
      expect(_activeTotal(list), 3590); // ya no suma
    });

    test('editar concepto y monto', () async {
      final id = await repo.add(concept: 'Movistar', amountCents: 3590);
      await repo.edit(id: id, concept: 'Movistar Fibra', amountCents: 4990);

      final row = (await repo.watchAll().first).single;
      expect(row.concept, 'Movistar Fibra');
      expect(row.amountCents, 4990);
    });

    test('eliminar', () async {
      final id = await repo.add(concept: 'Temporal', amountCents: 1000);
      await repo.delete(id);
      expect(await repo.watchAll().first, isEmpty);
    });
  });

  group('fixedExpenseTotalCentsProvider (RN-02)', () {
    test('suma sólo los gastos fijos activos', () async {
      final container = ProviderContainer(
        overrides: [
          fixedExpensesProvider.overrideWith(
            (ref) => Stream.value([
              const FixedExpense(
                  id: 1, concept: 'Movistar', amountCents: 3590, active: true),
              const FixedExpense(
                  id: 2, concept: 'Cupo', amountCents: 20000, active: true),
              const FixedExpense(
                  id: 3, concept: 'Pausado', amountCents: 999900, active: false),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(fixedExpensesProvider.future);
      expect(container.read(fixedExpenseTotalCentsProvider), 23590);
    });
  });
}
