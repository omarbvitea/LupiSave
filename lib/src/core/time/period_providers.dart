import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/time/period.dart';

/// Fuente de "ahora" inyectable. Por defecto es el reloj real del dispositivo;
/// en los tests se sustituye por una fecha fija para resultados deterministas.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// El periodo actual según el reloj (p. ej. hoy = agosto 2026 → Agosto 2026).
final currentPeriodProvider = Provider<Period>((ref) {
  final now = ref.watch(clockProvider)();
  return Period.fromDate(now);
});

/// El periodo que la app está mostrando. Arranca en el periodo actual (RF-03:
/// por defecto el mes actual) y en la Etapa 9 podrá moverse a otros meses.
final selectedPeriodProvider = StateProvider<Period>((ref) {
  return ref.read(currentPeriodProvider);
});
