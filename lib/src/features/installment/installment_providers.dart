import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';
import 'package:app/src/core/time/period_providers.dart';
import 'package:app/src/features/installment/installment_repository.dart';
import 'package:app/src/features/installment/installment_status.dart';

final installmentRepositoryProvider = Provider<InstallmentRepository>((ref) {
  return InstallmentRepository(ref.watch(databaseProvider));
});

/// Lista reactiva de todas las cuotas.
final installmentsProvider = StreamProvider<List<Installment>>((ref) {
  return ref.watch(installmentRepositoryProvider).watchAll();
});

/// Suma en céntimos de las cuotas **vigentes** en el periodo seleccionado
/// (RN-03). Depende del periodo: cambia solo al navegar de mes.
final vigenteInstallmentTotalCentsProvider = Provider<int>((ref) {
  final installments = ref.watch(installmentsProvider).valueOrNull ?? const [];
  final period = ref.watch(selectedPeriodProvider);
  return installments
      .where((i) => installmentStatus(i, period) == InstallmentStatus.vigente)
      .fold<int>(0, (sum, i) => sum + i.amountCents);
});
