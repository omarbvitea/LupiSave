import 'package:intl/intl.dart';

/// Formato monetario único de la app (RNF-04).
///
/// Toda cifra de dinero se muestra como **S/ 3.370,00**: símbolo `S/`,
/// separador de miles `.` y separador decimal `,`, siempre con dos decimales.
///
/// Regla de precisión: internamente el dinero se representa en **céntimos**
/// (enteros) para evitar los errores de coma flotante. `S/ 1.213,17` se guarda
/// como `121317`. La conversión a/desde céntimos vive aquí para que ninguna
/// otra capa reinvente el redondeo.
class Money {
  Money._();

  static const String symbol = 'S/';

  // Locale 'es' (España): agrupa miles con '.' y decimaliza con ',', que es
  // exactamente el formato pedido por el documento. Se formatea sólo el número
  // y el símbolo se antepone a mano, porque el patrón de moneda de 'es' coloca
  // el símbolo al final ("3.370,00 EUR"); aquí lo queremos delante.
  static final NumberFormat _formatter = NumberFormat('#,##0.00', 'es');

  /// Formatea un valor en **soles** (decimal) a texto: `3370.0 -> "S/ 3.370,00"`.
  static String format(num soles) => '$symbol ${_formatter.format(soles)}';

  /// Formatea un valor en **céntimos** (entero): `121317 -> "S/ 1.213,17"`.
  static String formatCents(int cents) => format(cents / 100);

  /// Convierte soles a céntimos con redondeo consistente: `1213.17 -> 121317`.
  static int toCents(num soles) => (soles * 100).round();

  /// Interpreta lo que el usuario escribió en un campo de monto y lo devuelve en
  /// **céntimos**, o `null` si no es un número válido. Acepta separador decimal
  /// `.` o `,`, y el formato con miles `1.370,00`. No valida el signo: el
  /// llamador decide si exige `> 0`.
  static int? tryParseToCents(String input) {
    var s = input.trim();
    if (s.isEmpty) return null;
    final hasDot = s.contains('.');
    final hasComma = s.contains(',');
    if (hasDot && hasComma) {
      // Formato local "1.370,00": '.' son miles, ',' es el decimal.
      s = s.replaceAll('.', '').replaceAll(',', '.');
    } else if (hasComma) {
      s = s.replaceAll(',', '.');
    }
    final value = double.tryParse(s);
    if (value == null) return null;
    return toCents(value);
  }

  /// Convierte céntimos a soles: `121317 -> 1213.17`.
  static double fromCents(int cents) => cents / 100;
}
