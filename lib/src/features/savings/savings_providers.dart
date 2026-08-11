import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/features/closure/closure_providers.dart';

/// Saldo del ahorro acumulado (RN-18): suma de los aportes de todos los cierres.
/// Independiente del periodo consultado.
final savingsBalanceCentsProvider = Provider<int>((ref) {
  final closures = ref.watch(closuresProvider).valueOrNull ?? const [];
  return closures.fold<int>(0, (s, c) => s + c.totalContributionCents);
});
