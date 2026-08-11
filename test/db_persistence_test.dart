import 'package:app/src/core/db/app_database.dart';
import 'package:app/src/core/db/meta_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Drift persiste y el stream refleja el cambio (RNF-01)', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = AppMetaRepository(db);

    // Estado inicial.
    expect(await repo.watchInt(MetaKeys.appOpenCount).first, 0);

    // Escribir emite un nuevo valor en el stream (base de la reactividad que
    // usará el Dashboard: Drift emite -> Riverpod propaga -> UI se reconstruye).
    await repo.incrementInt(MetaKeys.appOpenCount);
    expect(await repo.watchInt(MetaKeys.appOpenCount).first, 1);

    await repo.incrementInt(MetaKeys.appOpenCount);
    expect(await repo.watchInt(MetaKeys.appOpenCount).first, 2);

    // Un valor de texto arbitrario también sobrevive.
    await repo.writeString('nota', 'hola');
    expect(await repo.readString('nota'), 'hola');
  });
}
