import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/db/app_database.dart';

/// Provee la instancia única de la base de datos a toda la app.
///
/// Al ser un provider de Riverpod, cualquier capa (repositorios, pantallas)
/// obtiene la MISMA [AppDatabase] sin pasarla a mano por los constructores.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
