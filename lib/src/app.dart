import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/app_shell.dart';
import 'package:app/src/core/theme/app_theme.dart';
import 'package:app/src/features/onboarding/onboarding_flow.dart';

/// Modo de tema activo. Por defecto sigue al sistema (claro/oscuro), y puede
/// forzarse desde la UI. Al ser un provider, cualquier pantalla puede leerlo o
/// cambiarlo sin acoplarse a la raíz.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Raíz de la app. Cablea los temas claro y oscuro del design system y entrega
/// el Dashboard (P1) como pantalla principal.
class VitensesApp extends ConsumerWidget {
  const VitensesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Vitenses',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      // Respetamos el tamaño de fuente del sistema (accesibilidad) pero lo
      // acotamos: sin tope, un ajuste grande del sistema agranda todo y desborda
      // los layouts de altura fija (p. ej. el pill del bottom nav).
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: child!,
      ),
      // Usuarios nuevos (sin el flag de onboarding) ven el flujo de bienvenida;
      // al terminarlo se invalida el provider y la app rearma en el shell.
      home: ref.watch(onboardingDoneProvider).when(
            data: (done) => done ? const AppShell() : const OnboardingFlow(),
            loading: () => const Scaffold(),
            error: (_, _) => const AppShell(),
          ),
    );
  }
}
