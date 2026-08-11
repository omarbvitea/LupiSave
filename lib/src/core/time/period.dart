import 'package:flutter/foundation.dart';

/// Un **periodo**: un mes calendario, del día 1 al último día (sección 2 del
/// documento de requerimientos). Todo cálculo de la app se evalúa contra un
/// periodo. Es un value object inmutable, comparable y persistible.
@immutable
class Period implements Comparable<Period> {
  const Period(this.year, this.month)
      : assert(month >= 1 && month <= 12, 'El mes debe estar entre 1 y 12');

  /// El periodo al que pertenece una fecha.
  factory Period.fromDate(DateTime date) => Period(date.year, date.month);

  /// El periodo del mes en curso, según el reloj real.
  factory Period.current() => Period.fromDate(DateTime.now());

  /// Reconstruye desde su clave persistida `"2026-08"`.
  factory Period.parse(String key) {
    final parts = key.split('-');
    if (parts.length != 2) {
      throw FormatException('Clave de periodo inválida: $key');
    }
    return Period(int.parse(parts[0]), int.parse(parts[1]));
  }

  final int year;

  /// Mes 1–12 (1 = enero).
  final int month;

  // --- Navegación entre periodos (base de la Etapa 9) ----------------------

  Period get next => month == 12 ? Period(year + 1, 1) : Period(year, month + 1);
  Period get previous =>
      month == 1 ? Period(year - 1, 12) : Period(year, month - 1);

  /// ¿Este periodo es anterior al mes en curso? Los registros de meses pasados
  /// son de solo lectura: no se crean, editan ni eliminan (RN-23).
  bool get isPast => compareTo(Period.current()) < 0;

  // --- Rango de fechas del periodo -----------------------------------------

  /// Primer día del mes (00:00).
  DateTime get firstDay => DateTime(year, month, 1);

  /// Último día del mes (día 0 del mes siguiente = último del actual).
  DateTime get lastDay => DateTime(year, month + 1, 0);

  /// ¿La fecha [date] cae dentro de este periodo? (RN-07: gastos del periodo).
  /// Se compara sólo por día, ignorando la hora.
  bool containsDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return !day.isBefore(firstDay) && !day.isAfter(lastDay);
  }

  /// ¿El rango [start]–[end] se superpone con este periodo? (RN-03: una cuota
  /// está vigente si su inicio es ≤ al fin del periodo y su fin es ≥ al inicio).
  bool overlapsRange(DateTime start, DateTime end) {
    return !start.isAfter(lastDay) && !end.isBefore(firstDay);
  }

  // --- Persistencia y presentación -----------------------------------------

  /// Clave estable para guardar/ordenar: `"2026-08"`.
  String get key => '$year-${month.toString().padLeft(2, '0')}';

  /// Nombre del mes en español (RNF-05), con inicial mayúscula: `"Agosto"`.
  String get monthName => _monthNames[month - 1];

  /// Etiqueta completa para la UI: `"Agosto 2026"`.
  String get label => '$monthName $year';

  /// Etiqueta compacta para espacios estrechos: `"Ago 26"`.
  String get shortLabel =>
      '${_monthAbbr[month - 1]} ${(year % 100).toString().padLeft(2, '0')}';

  static const List<String> _monthAbbr = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  static const List<String> _monthNames = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  @override
  int compareTo(Period other) =>
      year != other.year ? year - other.year : month - other.month;

  @override
  bool operator ==(Object other) =>
      other is Period && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => 'Period($key)';
}
