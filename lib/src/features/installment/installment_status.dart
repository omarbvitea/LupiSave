import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/time/period.dart';

/// Estado de una cuota respecto a un periodo (RN-13, vigencia automática).
enum InstallmentStatus {
  futura('Futura'),
  vigente('Vigente'),
  finalizada('Finalizada');

  const InstallmentStatus(this.label);

  final String label;
}

/// Calcula el estado de [i] en el periodo [p]. Vigente = su rango se superpone
/// con el periodo (RN-03, vía [Period.overlapsRange]); si no, es futura cuando
/// aún no empieza y finalizada cuando ya terminó.
InstallmentStatus installmentStatus(Installment i, Period p) {
  if (p.overlapsRange(i.startDate, i.endDate)) return InstallmentStatus.vigente;
  return i.startDate.isAfter(p.lastDay)
      ? InstallmentStatus.futura
      : InstallmentStatus.finalizada;
}
