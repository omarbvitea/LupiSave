import 'package:app/src/core/time/period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Period — identidad y navegación', () {
    test('el periodo de una fecha es su año/mes', () {
      final p = Period.fromDate(DateTime(2026, 8, 8));
      expect(p, const Period(2026, 8));
      expect(p.label, 'Agosto 2026'); // nombre en español (RNF-05)
      expect(p.shortLabel, 'Ago 26'); // etiqueta compacta
      expect(const Period(2026, 12).shortLabel, 'Dic 26');
    });

    test('siguiente y anterior cruzan el cambio de año', () {
      expect(const Period(2026, 12).next, const Period(2027, 1));
      expect(const Period(2026, 1).previous, const Period(2025, 12));
      expect(const Period(2026, 8).next, const Period(2026, 9));
    });

    test('clave estable ida y vuelta', () {
      expect(const Period(2026, 8).key, '2026-08');
      expect(Period.parse('2026-08'), const Period(2026, 8));
    });

    test('comparación e igualdad', () {
      expect(const Period(2026, 8) == const Period(2026, 8), isTrue);
      expect(const Period(2026, 8).compareTo(const Period(2026, 9)), lessThan(0));
      expect(const Period(2027, 1).compareTo(const Period(2026, 12)),
          greaterThan(0));
    });
  });

  group('Period — rangos de fecha', () {
    test('primer y último día del mes', () {
      const p = Period(2026, 8);
      expect(p.firstDay, DateTime(2026, 8, 1));
      expect(p.lastDay, DateTime(2026, 8, 31));
      // Febrero de año bisiesto.
      expect(const Period(2028, 2).lastDay, DateTime(2028, 2, 29));
    });

    test('containsDate (RN-07): sólo fechas dentro del mes', () {
      const p = Period(2026, 8);
      expect(p.containsDate(DateTime(2026, 8, 1)), isTrue);
      expect(p.containsDate(DateTime(2026, 8, 31, 23, 59)), isTrue);
      expect(p.containsDate(DateTime(2026, 7, 31)), isFalse);
      expect(p.containsDate(DateTime(2026, 9, 1)), isFalse);
    });

    test('overlapsRange (RN-03): vigencia de cuotas', () {
      const agosto = Period(2026, 8);
      // Baldo celular: ago–sep 2026 → vigente en agosto.
      expect(
        agosto.overlapsRange(DateTime(2026, 8, 1), DateTime(2026, 9, 30)),
        isTrue,
      );
      // Monitor OLED: sep–nov 2026 → NO vigente en agosto.
      expect(
        agosto.overlapsRange(DateTime(2026, 9, 1), DateTime(2026, 11, 30)),
        isFalse,
      );
      // Un rango que termina justo el primer día del periodo sí toca.
      expect(
        agosto.overlapsRange(DateTime(2026, 6, 1), DateTime(2026, 8, 1)),
        isTrue,
      );
    });
  });
}
