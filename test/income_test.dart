import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/format/money.dart';
import 'package:app/src/features/income/income_providers.dart';
import 'package:app/src/features/income/income_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

int _activeTotal(List<Income> list) =>
    list.where((i) => i.active).fold<int>(0, (s, i) => s + i.amountCents);

void main() {
  group('IncomeRepository — CRUD y desactivación (RF-07)', () {
    late AppDatabase db;
    late IncomeRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = IncomeRepository(db);
    });
    tearDown(() => db.close());

    test('alta, orden alfabético y total de activos (RN-01)', () async {
      await repo.add(source: 'Unicorp', amountCents: 200000);
      await repo.add(source: 'Sueldo', amountCents: 137000);

      final list = await repo.watchAll().first;
      expect(list.map((e) => e.source), ['Sueldo', 'Unicorp']); // ordenado
      expect(_activeTotal(list), 337000); // S/ 3.370,00
      expect(Money.formatCents(_activeTotal(list)), 'S/ 3.370,00');
    });

    test('desactivar excluye del total sin eliminar', () async {
      await repo.add(source: 'Sueldo', amountCents: 137000);
      await repo.add(source: 'Unicorp', amountCents: 200000);
      var list = await repo.watchAll().first;
      final unicorp = list.firstWhere((e) => e.source == 'Unicorp');

      await repo.setActive(id: unicorp.id, active: false);
      list = await repo.watchAll().first;

      expect(list.length, 2); // sigue existiendo
      expect(_activeTotal(list), 137000); // ya no suma
    });

    test('editar nombre y monto', () async {
      final id = await repo.add(source: 'Sueldo', amountCents: 137000);
      await repo.edit(id: id, source: 'Sueldo SAC', amountCents: 150000);

      final row = (await repo.watchAll().first).single;
      expect(row.source, 'Sueldo SAC');
      expect(row.amountCents, 150000);
    });

    test('eliminar', () async {
      final id = await repo.add(source: 'Temporal', amountCents: 1000);
      await repo.delete(id);
      expect(await repo.watchAll().first, isEmpty);
    });
  });

  group('incomeTotalCentsProvider (RN-01)', () {
    test('suma sólo las fuentes activas', () async {
      final container = ProviderContainer(
        overrides: [
          incomesProvider.overrideWith(
            (ref) => Stream.value([
              const Income(
                id: 1,
                source: 'Sueldo',
                amountCents: 137000,
                active: true,
              ),
              const Income(
                id: 2,
                source: 'Unicorp',
                amountCents: 200000,
                active: true,
              ),
              const Income(
                id: 3,
                source: 'Pausada',
                amountCents: 999900,
                active: false,
              ),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(incomesProvider.future);
      expect(container.read(incomeTotalCentsProvider), 337000);
    });
  });
}
