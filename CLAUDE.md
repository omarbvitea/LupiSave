# CLAUDE.md — Vitenses (LupiSave)

App de finanzas personales (Flutter, iOS + Android), método 50/30/20, un solo usuario,
offline-first, soles peruanos, español. Este archivo describe **cómo está armado el proyecto**
y las reglas que todo cambio debe respetar.

## Fuentes de verdad — leer siempre antes de tocar UI o lógica

- **`specs/DESIGN.md`** — design system: colores, tipografía, espaciado, radios y componentes.
  Todo color/texto/spacing sale de aquí. **Nunca** hardcodear.
- **`specs/REQ_SPECS.md`** — requerimientos: reglas de negocio (RN-xx), funcionales (RF-xx),
  modelo de datos, pantallas (P1–P8) y el caso de prueba de agosto 2026. Toda lógica de
  presupuesto/ahorro/cierre se justifica contra una RN/RF concreta.

## Arquitectura

Flutter + **Riverpod** (estado) + **Drift** (persistencia local, offline-first). Punto de
entrada `lib/main.dart` → `lib/src/app.dart` (`VitensesApp`, cablea temas y home).

Capas dentro de `lib/src/`:

- **`core/`** — cimientos sin UI:
  - `budget/budget.dart` — **motor de cálculo puro** (Dart, sin Flutter ni Drift): dado los
    totales del periodo devuelve `PeriodSummary`/`EnvelopeSummary` según RN-04..RN-11.
    Determinista y fácil de testear. El dinero se maneja en **céntimos enteros** (RNF-04).
  - `format/money.dart` — formato monetario único (`S/ 1.240,50`, es-PE) y parseo/redondeo.
  - `time/period.dart` + `time/period_providers.dart` — `Period` (mes calendario) y el
    `selectedPeriodProvider` contra el que se evalúa todo.
  - `db/` — Drift (`app_database.dart`, `.g.dart` generado) y providers de base de datos.
  - `theme/` — tokens del design system: `AppColors`, `AppTypography`, `AppSpacing`/`AppRadius`
    y `AppTheme` (arma los `ThemeData` claro/oscuro).
- **`features/<feature>/`** — cada dominio (dashboard, expense, income, fixed_expense,
  installment, savings, closure, budget, seed) sigue el patrón
  **repository → providers → screen/editor**. Los providers componen datos crudos + el motor
  de `core/budget`.
- **`shared/widgets/`** — componentes del design system (`AppCard`, `AppButton`, `AppTextField`,
  `MoneyField`, `MoneyText`, `AppProgressBar`, `StatusChip`, `CategorySelector`). Inventario
  1:1 con `DESIGN.md §4`: no inventar componentes nuevos ahí sin razón; si un widget es de una
  sola pantalla, déjalo privado en esa pantalla.

## Reglas de estilo/UI (obligatorias)

- **Colores solo por token.** Usar `AppColors.*` y `Theme.of(context).colorScheme/textTheme`.
  **Evitar `Colors.white`, `Colors.black` y `Color(0x..)` sueltos** en pantallas/widgets —
  usar el token equivalente (`onPrimary` para texto sobre violeta, `surface`, `border`,
  `textSecondary`, etc.). Los hex solo viven en `core/theme/app_colors.dart`.
- **Tipografía por token.** Estilos desde `textTheme` (mapeado en `AppTypography`), no
  `TextStyle` con tamaños mágicos salvo casos hero justificados.
- **Espaciado/radios** desde `AppSpacing`/`AppRadius` (escala de 4px).
- **Montos** solo con `MoneyText`/`Money` — nunca formatear a mano.
- **Copy**: español (Perú), informal "tú", **sentence case** siempre. Sin emojis en UI (solo
  calidez puntual en texto). La app **nunca** infiere ni sugiere categorías (RN-21).
- Modo claro: `bg` == `surface` (blanco); cards e inputs se distinguen por su **borde**.

## Tests

- `flutter test` corre toda la suite (`test/*.dart`).
- En **widget-tests que montan el dashboard/summary, evitar Drift real**: overridear
  `periodSummaryProvider` y `monthCloseStartupProvider` con valores fijos (si se usa Drift real,
  quedan timers pendientes y `pumpAndSettle` no termina). Ver `test/dashboard_screen_test.dart`
  y `test/period_navigation_test.dart` como patrón.
- `flutter analyze` (o MCP `dart analyze_files`) debe quedar limpio.
