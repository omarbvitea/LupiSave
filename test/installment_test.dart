import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/format/money.dart';
import 'package:app/src/core/time/period.dart';
import 'package:app/src/features/installment/installment_repository.dart';
import 'package:app/src/features/installment/installment_status.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

int _vigenteTotal(List<Installment> list, Period p) => list
    .where((i) => installmentStatus(i, p) == InstallmentStatus.vigente)
    .fold<int>(0, (s, i) => s + i.amountCents);

/// Alta de las 3 cuotas reales del caso de prueba.
Future<void> _seedReales(InstallmentRepository repo) async {
  await repo.add(
      concept: 'Monitor OLED',
      amountCents: 65370,
      start: DateTime(2026, 9),
      end: DateTime(2026, 11));
  await repo.add(
      concept: 'Baldo celular',
      amountCents: 44667,
      start: DateTime(2026, 8),
      end: DateTime(2026, 9));
  await repo.add(
      concept: 'Macbook',
      amountCents: 76650,
      start: DateTime(2026, 8),
      end: DateTime(2026, 12));
}

void main() {
  group('InstallmentRepository — CRUD y vigencia (RF-06, RN-03)', () {
    late AppDatabase db;
    late InstallmentRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = InstallmentRepository(db);
    });
    tearDown(() => db.close());

    test('normaliza fechas al primer/último día de su mes', () async {
      await repo.add(
          concept: 'Macbook',
          amountCents: 76650,
          start: DateTime(2026, 8, 17), // día 17
          end: DateTime(2026, 12, 3)); // día 3

      final row = (await repo.watchAll().first).single;
      expect(row.startDate, DateTime(2026, 8, 1));
      expect(row.endDate, DateTime(2026, 12, 31));
    });

    test('vigente en agosto 2026 = S/ 1.213,17 (RN-03)', () async {
      await _seedReales(repo);
      final list = await repo.watchAll().first;

      const agosto = Period(2026, 8);
      // Monitor OLED (sep–nov) todavía es futura; Baldo + Macbook vigentes.
      expect(_vigenteTotal(list, agosto), 121317);
      expect(Money.formatCents(_vigenteTotal(list, agosto)), 'S/ 1.213,17');
    });

    test('fuera de todos los rangos (enero 2027) = S/ 0,00', () async {
      await _seedReales(repo);
      final list = await repo.watchAll().first;
      expect(_vigenteTotal(list, const Period(2027, 1)), 0);
    });

    test('editar y eliminar', () async {
      final id = await repo.add(
          concept: 'Temporal',
          amountCents: 1000,
          start: DateTime(2026, 8),
          end: DateTime(2026, 8));
      await repo.edit(
          id: id,
          concept: 'Temporal 2',
          amountCents: 2000,
          start: DateTime(2026, 8),
          end: DateTime(2026, 10));
      var row = (await repo.watchAll().first).single;
      expect(row.concept, 'Temporal 2');
      expect(row.amountCents, 2000);
      expect(row.endDate, DateTime(2026, 10, 31));

      await repo.delete(id);
      expect(await repo.watchAll().first, isEmpty);
    });
  });

  group('installmentStatus (RN-13)', () {
    final macbook = Installment(
      id: 1,
      concept: 'Macbook',
      amountCents: 76650,
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 12, 31),
    );

    test('futura antes de empezar', () {
      expect(installmentStatus(macbook, const Period(2026, 7)),
          InstallmentStatus.futura);
    });
    test('vigente dentro del rango', () {
      expect(installmentStatus(macbook, const Period(2026, 10)),
          InstallmentStatus.vigente);
    });
    test('finalizada después de terminar', () {
      expect(installmentStatus(macbook, const Period(2027, 1)),
          InstallmentStatus.finalizada);
    });
  });
}
