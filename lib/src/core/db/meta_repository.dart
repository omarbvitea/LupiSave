import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/database_provider.dart';

/// Llaves de los metadatos guardados en la tabla [AppMeta]. Centralizadas para
/// no repetir strings sueltos por el código.
class MetaKeys {
  MetaKeys._();

  /// Cuántas veces se ha abierto la app. Sirve para demostrar de forma visible
  /// que la persistencia sobrevive al reinicio (Etapa 1).
  static const String appOpenCount = 'app_open_count';

  /// Periodo abierto: el mes hasta el que el cierre automático ya avanzó. Al
  /// entrar a la app se cierran los periodos entre este y el actual (Etapa 10).
  static const String openPeriod = 'open_period';

  /// `'1'` cuando el usuario ya completó el onboarding. Mientras no exista,
  /// la app arranca en [OnboardingFlow] en vez del shell normal.
  static const String onboardingDone = 'onboarding_done';
}

/// Acceso tipado a los metadatos de la app. Las pantallas y providers hablan
/// con este repositorio, no directamente con la base de datos.
class AppMetaRepository {
  AppMetaRepository(this._db);

  final AppDatabase _db;

  Stream<int> watchInt(String key) => _db.watchIntMeta(key);
  Future<int> incrementInt(String key) => _db.incrementIntMeta(key);
  Future<String?> readString(String key) => _db.readMeta(key);
  Future<void> writeString(String key, String value) =>
      _db.writeMeta(key, value);
}

final metaRepositoryProvider = Provider<AppMetaRepository>((ref) {
  return AppMetaRepository(ref.watch(databaseProvider));
});
