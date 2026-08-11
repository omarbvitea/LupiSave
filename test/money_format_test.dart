import 'package:app/src/core/format/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money — formato peruano (RNF-04)', () {
    test('miles con «.» y decimales con «,», símbolo S/', () {
      expect(Money.format(3370), 'S/ 3.370,00');
      expect(Money.format(449.70), 'S/ 449,70');
      expect(Money.format(684.13), 'S/ 684,13');
    });

    test('formato desde céntimos enteros', () {
      expect(Money.formatCents(121317), 'S/ 1.213,17');
      expect(Money.formatCents(67400), 'S/ 674,00');
    });

    test('negativos conservan el signo', () {
      expect(Money.format(-150.5), 'S/ -150,50');
    });
  });

  group('Money — precisión en céntimos', () {
    test('soles → céntimos redondea consistente', () {
      expect(Money.toCents(1213.17), 121317);
      expect(Money.toCents(449.70), 44970);
      expect(Money.toCents(0.1 + 0.2), 30); // sin arrastre de coma flotante
    });

    test('céntimos → soles', () {
      expect(Money.fromCents(121317), 1213.17);
    });
  });

  group('Money — parseo de lo que escribe el usuario', () {
    test('acepta punto o coma como decimal', () {
      expect(Money.tryParseToCents('1370'), 137000);
      expect(Money.tryParseToCents('1370,50'), 137050);
      expect(Money.tryParseToCents('1370.50'), 137050);
    });

    test('acepta formato con miles 1.370,00', () {
      expect(Money.tryParseToCents('1.370,00'), 137000);
      expect(Money.tryParseToCents('2.000,00'), 200000);
    });

    test('devuelve null si no es número', () {
      expect(Money.tryParseToCents(''), isNull);
      expect(Money.tryParseToCents('abc'), isNull);
    });
  });
}
