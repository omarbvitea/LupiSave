# LupiSave — Design System

App de finanzas personales (Flutter, iOS + Android). Método 50/30/20 — Gasto Mensual (50%),
Entretenimiento (30%), Ahorro (20%). Un solo usuario, offline-first, soles peruanos (S/), solo
español. **Lupi**, la mascota (perrita), acompaña momentos clave: registrar un gasto, ahorro,
estados vacíos, aliento. Soporta **modo claro y modo oscuro**.

---

## 1. Color

Un solo violeta de marca. Colores semánticos separados del color de marca (no reutilizar el
violeta para positivo/negativo/advertencia). Máximo dos tonos de fondo por pantalla.

### 1.1 Marca

| Token | Claro | Oscuro | Uso |
|---|---|---|---|
| `primary` | `#7C5CFF` | `#7C5CFF` | Marca, botones, hero card del dashboard |
| `primaryLight` | `#B59BFF` | `#B59BFF` | Estados hover/disabled del primario, acentos suaves |
| `primaryDark` | `#5F3FE0` | `#5F3FE0` | Press state del primario |
| `onPrimary` | `#FFFFFF` | `#FFFFFF` | Texto/icono sobre fondo primario |
| `savings` | `#7C5CFF` | `#7C5CFF` | Acento de ahorro (mismo violeta) |
| `savingsSurface` | `#EDE9FE` | `#332C5C` * | Fondo de card de ahorro |
| `highlight` | `#FFC857` | `#FFC857` | Resalte cálido puntual (badges, tajada "sobrante") |
| `accentLight` / `accentDark` | `#F1ECFF` | `#322B54` | Accent suave (morado casi blanco) para cards de ánimo |

\* Superficie oscura de ahorro no está en el codebase fuente — usar violeta oscuro desaturado
consistente con `surfaceVariantDark`; ajustar a ojo antes de shippear.

### 1.2 Semánticos

| Token | Claro | Oscuro | Uso |
|---|---|---|---|
| `positive` | `#4CC38A` | `#4CC38A` | Disponible, saldo positivo |
| `positiveSurface` | `#E3F6EE` | `#1E3A2E` * | Fondo de card/chip positivo |
| `negative` | `#E0483B` | `#E0483B` | Sobregasto, saldo negativo |
| `negativeSurface` | `#FCE9E7` | `#3A2320` * | Fondo de card/chip negativo |
| `warning` | `#E8A020` | `#E8A020` | Sobre 75–100% de un sobre (envelope) |
| `warningSurface` | `#FDF3E1` | `#3A2E17` * | Fondo de card/chip de advertencia |

\* Superficies semánticas oscuras tampoco están en el codebase — mismo criterio: color base sin
cambios, superficie oscurecida y desaturada para mantener contraste AA sobre `bgDark`. Confirmar
antes de shippear.

### 1.3 Neutrales y superficies

| Token | Claro | Oscuro |
|---|---|---|
| `bg` | `#FFFFFF` | `#15141F` |
| `surface` | `#FFFFFF` | `#211F2E` |
| `surfaceVariant` | `#EDEFF3` | `#2C2A3B` |
| `textPrimary` | `#1E1E2F` | `#F2F3F7` |
| `textSecondary` | `#5B6472` | `#A6A2BE` |
| `border` | `#E2E5EB` | `#38364A` |
| `ink` | `#1E1E2F` | — (usar `textPrimary`) |

Reglas:
- En modo claro `bg` == `surface` (blanco): las cards e inputs se diferencian **solo por su
  borde** hairline, no por contraste de fondo. En oscuro sí hay contraste bg/surface.
- Fondos siempre planos — sin gradientes, sin texturas, sin fotografía. La única imagen full-bleed
  permitida es Lupi.
- Bordes hairline 1px con `border` en cards e inputs, no trazos gruesos. Las cards de estado usan
  borde del color de su superficie tintada (ej. borde violeta en la card de ahorro), no una barra
  de acento lateral.
- Modo oscuro no es solo invertir — usa las superficies "-dark" ya definidas arriba; no bajar la
  opacidad del violeta de marca ni de los semánticos, solo sus superficies de fondo.

### 1.4 Sombras y elevación

| Token | Valor |
|---|---|
| `shadowCard` | `0 1px 2px rgba(30,30,47,0.04), 0 4px 12px rgba(30,30,47,0.06)` |
| `shadowFloat` | `0 8px 24px rgba(124,92,255,0.28)` (glow violeta, solo el FAB) |

En Flutter: `BoxShadow` equivalentes con `blurRadius`/`offset` ~ análogos; en oscuro reducir
opacidad de `shadowCard` (superficies oscuras necesitan menos sombra, más contraste de borde).

### 1.5 Color de la mascota (Lupi) — referencia para producción de assets

*(Espacio reservado — completar con los valores exactos cuando se generen los assets finales de
Lupi. Descripción de referencia del brand board: pelaje blanco/negro, moño rojo, collar violeta.)*

| Elemento | Hex claro | Hex oscuro / contorno | Notas |
|---|---|---|---|
| Pelaje — base clara | `#` | — | |
| Pelaje — manchas oscuras | `#` | — | |
| Nariz / hocico | `#` | — | |
| Moño | `#` | — | probablemente rojo, confirmar tono exacto |
| Collar | `#` | — | probablemente `primary` o `primaryDark` |
| Contorno / línea | `#` | — | grosor de trazo también pendiente |
| Fondo de escena (si aplica en poses ilustradas) | `#` | `#` | debe funcionar sobre `bg`/`bgDark` |

Nota de uso: Lupi es la única ilustración del sistema — no crear iconografía ilustrada adicional
en su estilo. Debe quedar legible tanto sobre `bg` (claro) como sobre `bgDark` (oscuro); si el
arte final es un PNG con fondo transparente, verificar que ningún trazo oscuro se pierda sobre
`bgDark` y viceversa con trazos claros sobre `bg`.

---

## 2. Tipografía

Un solo tipo de letra: **Poppins** (Google Fonts, pesos 400/500/600/700). Sin serif, sin mono.

| Token | Tamaño | Peso recomendado | Uso |
|---|---|---|---|
| `display` | 40px | Bold (700) | Monto hero del dashboard |
| `displayMd` | 32px | Bold (700) | Montos grandes secundarios |
| `headline` | 22px | Semibold (600) | Títulos de pantalla |
| `titleLg` | 20px | Semibold (600) | Títulos de card |
| `titleMd` | 16px | Semibold (600) | Subtítulos |
| `titleSm` | 14px | Semibold (600) | Encabezados de sección |
| `bodyLg` | 16px | Regular (400) | Texto de cuerpo principal |
| `bodyMd` | 14px | Regular (400) | Texto de cuerpo secundario |
| `bodySm` | 12px | Regular (400) | Texto auxiliar, ayudas de formulario |
| `labelLg` | 15px | Medium (500) | Labels de botón |
| `labelMd` | 12px | Medium (500) | Labels de chip, tab bar |

Regla: Semibold/Bold para números, títulos y botones; Regular para cuerpo. Color de texto siempre
`textPrimary`/`textSecondary` según el token de modo activo — nunca hardcodear negro/gris.

---

## 3. Espaciado, radios y touch targets

Escala estricta de 4px, ligada a targets táctiles reales.

| Token | Valor |
|---|---|
| `spaceXxs` | 4px |
| `spaceXs` | 8px |
| `spaceSm` | 12px |
| `spaceMd` | 16px |
| `spaceLg` | 24px |
| `spaceXl` | 32px |
| `spaceXxl` | 48px |
| `touchTarget` | 48px mínimo — todo elemento tocable |

| Token | Valor | Uso |
|---|---|---|
| `radiusSm` | 8px | Elementos pequeños |
| `radiusMd` | 12px | Campos, botones |
| `radiusLg` | 16px | Cards |
| `radiusPill` | 999px | Chips |

---

## 4. Componentes

Inventario 1:1 con `shared/widgets/` del código Flutter — no inventar componentes fuera de esta
lista.

### Button
Botón de ancho completo. `variant`: `primary` (filled, violeta), `secondary` (outline), `ghost`
(texto). Props: `label`, `variant`, `icon`, `expand`, `disabled`, `onPressed`.
Press state: opacidad ~0.85 o escala 2–4% hacia abajo (no hay hover en mobile).

### Card
Caja base bordeada/redondeada para saldo, sobres (envelopes), ahorro, filas de lista.
Props: `child`, `color`, `borderColor`, `padding`, `onTap`.

### TextField
Input de texto con label. Usos: fuente de ingreso, concepto, descripción, motivo.
Props: `label`, `value`, `placeholder`, `maxLength`, `errorText`, `onChanged`.

### MoneyField
Input numérico grande con prefijo fijo "S/", primer campo del flujo de registro rápido de gasto,
autofocus + teclado numérico.
Props: `label`, `value`, `autofocus`, `errorText`, `onChanged`.

### SegmentedSelector
Fila de opciones siempre visibles, sin dropdown — la app nunca infiere ni sugiere una elección
(regla de producto RN-21). Uso: categoría de gasto (Gasto Mensual / Entretenimiento).
Props: `options`, `value`, `onChanged`.

### ProgressBar
Barra de uso de un sobre. El color lo decide quien lo llama según umbral: verde <80%, ámbar
80–100%, rojo >100%.
Props: `value`, `color`, `height`.

### StatusChip
Pastilla de estado pequeña — vigencia de cuota (Vigente/Futura/Finalizada), flags de déficit,
etiquetas de categoría.
Props: `label`, `color`, `surface`.

### MoneyText
Formatea un monto en soles (S/, separador de miles, 2 decimales); único lugar donde el monto se
colorea por signo (positivo/negativo).
Props: `amount`, `colorBySign`, `style`.
Formato: `S/ 1.240,50` (separador decimal coma, estilo es-PE) — es el formato fuente de verdad;
no usar el punto decimal.

---

## 5. Layout

- Tab bar inferior fija: Inicio, Gastos, **+ registrar** (FAB central, siempre el centro visual),
  Ahorros, Más.
- El FAB usa `shadowFloat` (glow violeta) para leerse como la acción primaria.
- Máximo dos tonos de fondo por pantalla (`bg` + `surface`).

## 6. Iconografía

Sin set de iconos propio en el código (usa glyphs nativos de Material). Sustituto recomendado
para web/prototipo: **Lucide** (mismo grosor de trazo que el estilo outlined de Material). Sin
emojis como iconos — los emojis solo aparecen inline en copy (ver Voz y tono), nunca en UI.

## 7. Voz y tono

- Español (Perú), informal "tú".
- Sentence case siempre — "Registra tus gastos", "¡Hola!", "Nuevo gasto" — nunca Title Case.
- Tono: cercano y motivador, simple y claro, positivo y alentador, compañero y confiable. Copy
  como un amigo que apoya, no un extracto bancario.
- Emojis solo para calidez en momentos puntuales (👋 en saludo, 🐾 cerca de mensajes de Lupi) —
  nunca decorando botones, labels o datos.
- La app nunca autoclasifica ni sugiere (RN-21) — el copy nunca implica que la app está adivinando
  por el usuario.

## 8. Animación e interacción

No definido en el código fuente original — recomendación: fades/scale-in rápidos (150–200ms
ease-out), nada rebotado ni llamativo (las finanzas deben sentirse en calma). Press state: opacidad
~0.85 o escala 2–4% hacia abajo en botones y cards tocables. Sin hover (mobile-only).

## 9. Modo oscuro — checklist de implementación

- [ ] Todos los tokens de superficie/texto/borde tienen ya su par `-dark` (sección 1.3) — usar
      `ThemeData`/`ColorScheme` de Flutter con `brightness` para alternar automáticamente.
- [ ] Definir superficies oscuras para `savingsSurface`, `positiveSurface`, `negativeSurface`,
      `warningSurface` (marcadas con * arriba — son propuestas, no verificadas contra el codebase).
- [ ] Confirmar contraste AA de `textSecondaryDark` (`#A6A2BE`) sobre `surfaceDark`/`bgDark`.
- [ ] Revisar `shadowCard`/`shadowFloat` en oscuro — sombras muy sutiles pueden desaparecer sobre
      fondos oscuros; considerar reforzar con borde en vez de sombra.
- [ ] Assets de Lupi: confirmar que el arte final (ver sección 1.5) se lee bien en ambos modos.

---

## 10. Fuentes de este documento

Basado en el design system LupiSave: código Flutter real (`lib/src/core/theme/*`,
`lib/src/shared/widgets/*`, `specs/REQ_SPECS.md`) para inventario de componentes, escala de
espaciado/radios y reglas de producto; brand board subido (paleta violeta, Poppins, mascota Lupi)
para identidad visual. Ver caveats abiertos: dirección de color a confirmar, formato de separador
decimal, assets de Lupi aislados aún no generados, pantallas P3–P8 (Historial, Gastos Fijos,
Cuotas, Ingresos, Ajustes) no construidas aún.
