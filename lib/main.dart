import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/app.dart';

void main() {
  runApp(
    // ProviderScope: raíz del manejo de estado (Riverpod). Todo provider
    // (base de datos, tema, y más adelante los datos de negocio) vive aquí.
    const ProviderScope(child: VitensesApp()),
  );
}
