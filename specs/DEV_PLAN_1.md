# Plan de Desarrollo — Fase 1 (MVP)
## App de Presupuesto Personal — Método 50/30/20

**Basado en:** Documento de Requerimientos v3.0  
**Objetivo de este documento:** Dividir la Fase 1 en etapas de desarrollo verificables, de modo que cada una pueda probarse y darse por cerrada antes de avanzar a la siguiente.

**Fuera de alcance de este documento:** Nombres de clases, paquetes específicos, código o cualquier detalle de implementación línea por línea. Eso se define en un documento técnico aparte. Sí se incluye, como Etapa 0, la definición de fundamentos técnicos y visuales que todo el resto del desarrollo va a usar.

---

## Cómo usar este documento

Cada etapa tiene:
- **Qué se construye** — el alcance funcional o técnico de ese paso.
- **Requerimientos y reglas que cubre** — referencia cruzada al documento de requerimientos.
- **Depende de** — qué etapas anteriores deben estar cerradas.
- **Checklist de verificación** — lo que debes poder hacer/ver para dar por aprobada la etapa.

Una etapa no se considera terminada hasta que todos los puntos de su checklist funcionan correctamente. Si algo falla o quieres un ajuste, se resuelve antes de pasar a la siguiente etapa.

---

## Vista general de las etapas

| Etapa | Nombre | Resultado tangible |
|-------|--------|---------------------|
| 0 | Fundamentos: Flutter, design system y arquitectura | El proyecto está creado, con su tema visual y su estructura definidos, listo para empezar a construir pantallas |
| 1 | Base de datos y estructura de periodos | La app arranca, guarda datos localmente y sabe en qué mes está |
| 2 | Ingresos | Puedes cargar y administrar tus fuentes de ingreso |
| 3 | Gastos fijos | Puedes cargar y administrar tus pagos recurrentes |
| 4 | Cuotas temporales | Puedes cargar compromisos con fecha de inicio/fin |
| 5 | Motor de cálculo del periodo | La app calcula sobres, disponible y porcentajes de uso |
| 6 | Dashboard (P1) | Ves el resumen del mes de un vistazo |
| 7 | Registrar gasto (P2) | Puedes anotar un gasto en menos de 10 segundos |
| 8 | Historial de gastos (P3) | Puedes revisar, filtrar, editar y borrar gastos pasados |
| 9 | Navegación entre periodos | Puedes moverte a meses pasados o futuros y ver sus datos |
| 10 | Cierre de mes automático | El sistema transfiere el remanente y aparta el ahorro sin que tengas que hacer nada |
| 11 | Ahorro y retiros (P7) | Ves tu ahorro acumulado, su historial, y puedes registrar retiros |
| 12 | Carga de datos iniciales | Se cargan tus datos reales (ingresos, gastos fijos, cuotas, gastos de agosto) |
| 13 | Validación integral contra el caso de prueba | Se confirma que todos los números coinciden con el caso de prueba del documento de requerimientos |

---

## Etapa 0 — Fundamentos: Flutter, design system y arquitectura

### Qué se construye
Todo lo que el resto de las etapas va a dar por hecho. No hay funcionalidad de negocio todavía; el resultado es un proyecto vacío pero sólido, sobre el cual construir sin retrabajo.

Incluye tres bloques:

**a) Configuración del proyecto Flutter**
- Proyecto creado con la última versión estable de Flutter.
- Configuración base para iOS y Android (nombre de la app, ícono provisional, splash screen provisional).
- Estructura de carpetas del proyecto definida y documentada, de forma que cualquier pantalla o funcionalidad nueva sepa "dónde va".
- Convenciones de código acordadas (formato, linter, nombres) para que el desarrollo de las siguientes etapas sea consistente.

**b) Design system / Theme**
- Paleta de colores definida: color principal, color de alerta/negativo, color de éxito/positivo, colores neutros para fondo y texto.
- Tipografía definida: familia tipográfica y escala de tamaños (títulos, cuerpo, cifras destacadas como el Disponible Actual).
- Espaciados y radios definidos (para que todas las tarjetas, botones y modales se vean consistentes entre sí).
- Modo claro y oscuro decidido (si aplica en el MVP o se pospone).
- Componentes base reutilizables construidos una sola vez y listos para usarse en cualquier pantalla: tarjeta genérica, botón primario/secundario, campo de texto, campo numérico de monto, selector de categoría, barra de progreso, chip de estado (Vigente/Futura/Finalizada), botón de acción flotante.

**c) Arquitectura del proyecto**
- Definición de cómo se organiza el código internamente (separación entre lo visual, la lógica de negocio y el almacenamiento local), sin necesidad de detallar clases específicas en este documento.
- Definición de cómo se manejará el estado de la app (por ejemplo, cómo se entera el Dashboard de que se registró un gasto nuevo sin recargar la app).
- Definición del mecanismo de almacenamiento local que se usará en la Etapa 1.

### Requerimientos y reglas que cubre
- RNF-08 (Flutter, una sola base de código para iOS y Android)
- RNF-01 (funcionamiento sin conexión) — se prepara el mecanismo de almacenamiento local
- RNF-09 (usabilidad con una mano) — se define desde el sistema de espaciados y la ubicación de componentes táctiles
- Base para RNF-04 (precisión monetaria) — se define cómo se formatean montos y moneda de forma consistente en todos los componentes

### Depende de
Nada. Es el punto de partida de todo el proyecto.

### Checklist de verificación
- [ ] El proyecto Flutter compila y corre sin errores en la última versión estable, tanto en un emulador/dispositivo Android como en uno iOS (o al menos se confirma que el código es compatible con ambos).
- [ ] Existe una paleta de colores documentada, y se puede ver aplicada en una pantalla de muestra (aunque sea una pantalla de prueba temporal, no una pantalla real de la app).
- [ ] Existe una escala tipográfica documentada y visible en esa misma pantalla de muestra.
- [ ] Los componentes base (tarjeta, botón, campo de texto, campo de monto, selector de categoría, barra de progreso, chip de estado, botón flotante) existen y se pueden ver renderizados juntos en una pantalla de muestra.
- [ ] Un monto de ejemplo se muestra correctamente formateado como moneda peruana (S/, separador de miles, dos decimales) usando el componente definido para esto.
- [ ] La estructura de carpetas del proyecto está clara y documentada, de forma que se pueda explicar en una frase dónde iría el código de una pantalla nueva, dónde la lógica de cálculo, y dónde el almacenamiento.
- [ ] Está decidido y probado (con un dato de ejemplo cualquiera) el mecanismo con el que la app va a guardar información en el dispositivo, antes de empezar a guardar datos reales en la Etapa 1.
- [ ] Está decidido cómo la app va a notificar a la pantalla principal cuando algo cambia en otra parte (por ejemplo, un gasto nuevo), aunque todavía no haya pantallas reales que lo prueben.

> Esta etapa se cierra cuando exista una app "cascarón": abre, se ve con la identidad visual definida, y tiene las piezas de construcción (componentes) listas para usarse — pero sin ninguna pantalla de negocio todavía.

---

## Etapa 1 — Base de datos y estructura de periodos

### Qué se construye
El motor interno que permite que la app guarde información real en el dispositivo y entienda el concepto de "periodo" (mes calendario), usando el mecanismo de almacenamiento definido en la Etapa 0. No hay pantallas de negocio visibles todavía, o como mucho una pantalla vacía de bienvenida.

### Requerimientos y reglas que cubre
- RNF-01 (funcionamiento sin conexión, almacenamiento local)
- RNF-04 (precisión monetaria, dos decimales)
- Concepto de Periodo (sección 2)

### Depende de
Etapa 0

### Checklist de verificación
- [ ] Al cerrar y volver a abrir la app, cualquier dato de prueba que se haya guardado sigue ahí (persistencia real, no en memoria).
- [ ] La app identifica correctamente el mes actual (agosto 2026) como periodo por defecto.
- [ ] No hay conexión a internet requerida para que la app funcione.

---

## Etapa 2 — Ingresos (P6)

### Qué se construye
Pantalla de Ingresos completa: listar, agregar, editar, eliminar y activar/desactivar fuentes de ingreso, usando los componentes visuales definidos en la Etapa 0.

### Requerimientos y reglas que cubre
- RF-07
- RN-01 (ingreso mensual total)
- RN-20 (ingreso fijo y editable, no por periodo)
- Modelo de datos 3.1

### Depende de
Etapa 1

### Checklist de verificación
- [ ] Puedo agregar una fuente de ingreso con nombre y monto.
- [ ] No me deja guardar un monto igual o menor a cero.
- [ ] Puedo editar el nombre o el monto de una fuente existente.
- [ ] Puedo eliminar una fuente.
- [ ] Puedo desactivar una fuente sin eliminarla, y veo que ya no cuenta en el total.
- [ ] La pantalla muestra el total sumado de todas las fuentes activas.
- [ ] Si cargo mis dos ingresos reales (Sueldo S/ 1.370,00 y Unicorp S/ 2.000,00), el total muestra S/ 3.370,00.
- [ ] La pantalla usa visualmente los componentes y colores definidos en la Etapa 0 (no estilos improvisados).

---

## Etapa 3 — Gastos fijos (P4)

### Qué se construye
Pantalla de Gastos fijos completa: listar, agregar, editar, eliminar y activar/desactivar.

### Requerimientos y reglas que cubre
- RF-05
- RN-02 (gastos fijos del mes)
- Modelo de datos 3.2

### Depende de
Etapa 1 (no depende de Ingresos, pero puede construirse en paralelo o justo después)

### Checklist de verificación
- [ ] Puedo agregar un gasto fijo con concepto y monto mensual.
- [ ] No me deja guardar un monto igual o menor a cero.
- [ ] Puedo editar y eliminar un gasto fijo.
- [ ] Puedo desactivar un gasto fijo y veo que deja de sumar en el total.
- [ ] La pantalla muestra el total al pie.
- [ ] Si cargo mis 8 gastos fijos reales, el total muestra S/ 449,70.

---

## Etapa 4 — Cuotas temporales (P5)

### Qué se construye
Pantalla de Cuotas temporales completa: listar, agregar, editar, eliminar, con cálculo de estado (Vigente, Futura, Finalizada) y meses restantes.

### Requerimientos y reglas que cubre
- RF-06
- RN-03 (cuotas vigentes del mes)
- RN-13 (vigencia automática)
- Modelo de datos 3.3

### Depende de
Etapa 1

### Checklist de verificación
- [ ] Puedo agregar una cuota con concepto, monto, fecha de inicio y fecha de fin.
- [ ] La app no me deja guardar una fecha de fin anterior a la fecha de inicio.
- [ ] Cada cuota muestra su estado correcto según el mes actual: Vigente, Futura o Finalizada, usando el componente "chip de estado" de la Etapa 0.
- [ ] Si cargo mis 3 cuotas reales (Monitor OLED, Baldo celular, Macbook) y me ubico en agosto 2026, el total vigente muestra S/ 1.213,17.
- [ ] Si me ubico en un mes fuera de todos los rangos (por ejemplo, enero 2027), el total vigente es S/ 0,00.
- [ ] Puedo editar y eliminar una cuota.

---

## Etapa 5 — Motor de cálculo del periodo

### Qué se construye
La lógica interna (sin pantalla propia, o con una pantalla de prueba temporal) que combina ingresos, gastos fijos, cuotas y gastos registrados para producir los números clave de un periodo: presupuesto de cada sobre, gastado, disponible, porcentaje de uso, ahorro apartado y disponible actual.

### Requerimientos y reglas que cubre
- RN-04, RN-05, RN-06, RN-07, RN-08, RN-09, RN-10, RN-11
- RN-12 (validación de porcentajes que sumen 100%)
- RN-14 (historicidad)

### Depende de
Etapas 2, 3, 4

### Checklist de verificación
- [ ] Con los datos reales cargados y sin gastos registrados aún, el ahorro apartado calcula S/ 674,00 (20% de S/ 3.370,00).
- [ ] El presupuesto de Gasto Mensual calcula S/ 1.685,00 (50%) y el de Entretenimiento S/ 1.011,00 (30%).
- [ ] El sobre Gasto Mensual muestra como "gastado" la suma de gastos fijos + cuotas vigentes, incluso sin ningún gasto registrado todavía.
- [ ] El sobre Entretenimiento muestra "gastado" en cero si no hay gastos registrados en esa categoría.
- [ ] Si el disponible de un sobre se vuelve negativo, el sistema lo permite y lo señala, no bloquea nada.
- [ ] Si edito un ingreso o gasto fijo después de tener gastos ya registrados en meses pasados, esos meses pasados no cambian sus números.

---

## Etapa 6 — Dashboard (P1)

### Qué se construye
La pantalla principal: tarjeta de Disponible Actual, tarjetas de los dos sobres con barra de progreso, tarjeta de ahorro (resumen), resumen secundario de ingreso/gastos fijos/cuotas, y el botón flotante para registrar gasto (el botón puede existir ya, aunque el modal se construya en la siguiente etapa).

### Requerimientos y reglas que cubre
- RF-04
- RN-11
- Pantalla P1 completa (sección 5)
- RNF-09 (usabilidad con una mano, alcance parcial)

### Depende de
Etapa 5

### Checklist de verificación
- [ ] Con los datos reales cargados (sin gastos registrados todavía), el Disponible Actual muestra S/ 2.033,13 (3.370 − 449,70 − 1.213,17 − 674).
- [ ] La tarjeta de Disponible Actual cambia de color cuando el valor es negativo, usando los colores definidos en la Etapa 0.
- [ ] Las dos tarjetas de sobre muestran presupuesto, gastado, disponible y una barra de progreso coherente con esos números.
- [ ] La tarjeta de ahorro se ve visualmente distinta a las de sobre (sin barra de progreso).
- [ ] El resumen secundario muestra correctamente ingreso total, gastos fijos y cuotas vigentes del mes.
- [ ] Toda la pantalla es legible y usable en un celular real, no solo en un emulador de escritorio.

---

## Etapa 7 — Registrar gasto (P2)

### Qué se construye
El modal de registro rápido de gasto: monto con teclado numérico y foco automático, categoría (dos botones visibles), descripción opcional, fecha preseleccionada en hoy.

### Requerimientos y reglas que cubre
- RF-01
- RN-07, RN-21 (la categoría la decide el usuario, sin sugerencias)
- Pantalla P2 completa
- RNF-02 (máximo tres interacciones, menos de diez segundos)

### Depende de
Etapa 6

### Checklist de verificación
- [ ] Al tocar el botón flotante, el modal abre con el teclado numérico ya activo, sin pasos previos.
- [ ] Puedo registrar un gasto completo (monto + categoría) en menos de 10 segundos y tres toques.
- [ ] No hay ningún tipo de sugerencia o autocompletado de categoría.
- [ ] Al guardar, el modal se cierra solo y el dashboard se actualiza sin recargar la app.
- [ ] Si registro los 4 gastos reales de agosto (Gasolina, Chifa CC, Pichanga, Comida y ropa, los cuatro en Entretenimiento), el Disponible Actual pasa a mostrar S/ 684,13.
- [ ] El sobre Entretenimiento pasa a mostrar S/ 349,00 gastado y S/ 662,00 disponible.

---

## Etapa 8 — Historial de gastos (P3)

### Qué se construye
Lista de gastos agrupada por fecha, con filtros por periodo y categoría, búsqueda por descripción, total del filtro, y acciones de editar/eliminar.

### Requerimientos y reglas que cubre
- RF-02
- Pantalla P3 completa

### Depende de
Etapa 7

### Checklist de verificación
- [ ] Veo los gastos agrupados por fecha, del más reciente al más antiguo (o el orden que se defina, pero consistente).
- [ ] Puedo filtrar por categoría y ver solo Gasto Mensual o solo Entretenimiento.
- [ ] Puedo buscar un gasto por texto de su descripción.
- [ ] El total mostrado arriba coincide exactamente con la suma de los gastos visibles según el filtro activo.
- [ ] Puedo editar un gasto (cambiar monto, categoría, fecha o descripción) y el dashboard refleja el cambio al volver.
- [ ] Al eliminar un gasto, la app pide confirmación antes de borrarlo.
- [ ] Después de eliminar, todos los totales (dashboard, sobres, historial) se actualizan correctamente.

---

## Etapa 9 — Navegación entre periodos

### Qué se construye
El selector de mes en el dashboard (y su reflejo en el historial), que permite moverse a cualquier mes pasado o futuro y ver todos los cálculos reevaluados para ese mes.

### Requerimientos y reglas que cubre
- RF-03
- RN-03, RN-07 a RN-11 reevaluados por periodo

### Depende de
Etapa 8

### Checklist de verificación
- [ ] Puedo avanzar y retroceder de mes en mes desde el dashboard.
- [ ] Al moverme a septiembre 2026, las cuotas vigentes cambian correctamente (Monitor OLED entra, Baldo celular sale).
- [ ] Al moverme a un mes sin ningún gasto registrado, el dashboard muestra ceros donde corresponde, sin errores.
- [ ] Los gastos del historial se filtran automáticamente según el mes seleccionado en el dashboard (o el filtro de periodo del historial, según cómo se conecten ambas pantallas).
- [ ] Volver al mes actual desde otro mes funciona sin recargar la app.

---

## Etapa 10 — Cierre de mes automático

### Qué se construye
La lógica que, al primer acceso tras terminar un periodo, calcula el remanente neto de los sobres, lo transfiere al ahorro junto con el apartado del mes, y deja un registro permanente de ese cierre. Esta etapa no tiene pantalla propia todavía (eso es la Etapa 11), pero su resultado debe poder verificarse en los datos internos.

### Requerimientos y reglas que cubre
- RF-11
- RN-16, RN-17, RN-18
- RNF-10 (idempotencia: ejecutarlo dos veces no duplica nada)
- RNF-11 (trazabilidad)
- Modelo de datos 3.6

### Depende de
Etapa 9

### Checklist de verificación
- [ ] Al simular que agosto 2026 terminó y entro a la app, se genera automáticamente un cierre para agosto sin que yo haga nada manualmente.
- [ ] El cierre generado para agosto muestra: ahorro apartado S/ 674,00, remanente neto S/ 684,13, aporte total S/ 1.358,13.
- [ ] Si es el primer cierre, el ahorro acumulado resultante es S/ 1.358,13.
- [ ] Si fuerzo que el cierre se ejecute una segunda vez para el mismo mes, el ahorro acumulado NO se duplica.
- [ ] Si simulo un mes donde el neto de los sobres es negativo, ese monto se resta correctamente del ahorro acumulado (no se ignora ni se pone en cero).
- [ ] Los sobres del nuevo mes arrancan desde su presupuesto completo, sin arrastrar el sobrante o el déficit del mes anterior.

---

## Etapa 11 — Ahorro y retiros (P7)

### Qué se construye
La pantalla dedicada de Ahorro: saldo acumulado destacado, historial de aportes mes a mes (con los meses de neto negativo diferenciados visualmente), historial de retiros, y la acción de registrar un nuevo retiro.

### Requerimientos y reglas que cubre
- RF-08, RF-09, RF-10
- RN-15, RN-19
- Modelo de datos 3.7
- Pantalla P7 completa

### Depende de
Etapa 10

### Checklist de verificación
- [ ] El saldo acumulado mostrado coincide exactamente con la suma de todos los cierres menos todos los retiros.
- [ ] Veo el historial de aportes mes a mes, con el detalle de apartado, remanente y aporte total de cada mes cerrado.
- [ ] Los meses con remanente neto negativo se distinguen visualmente de los positivos.
- [ ] Puedo registrar un retiro con monto y motivo.
- [ ] Después de un retiro, el saldo acumulado disminuye exactamente en ese monto.
- [ ] El retiro aparece en el historial de retiros, ordenado del más reciente al más antiguo.
- [ ] Registrar un retiro NO afecta el Disponible Actual del dashboard ni el gastado de ningún sobre.
- [ ] No existe, en ningún lugar de la app, la posibilidad de registrar un gasto con categoría "Ahorro".

---

## Etapa 12 — Carga de datos iniciales

### Qué se construye
El mecanismo para cargar de una sola vez el conjunto completo de datos reales del usuario (ingresos, gastos fijos, cuotas, gastos de agosto), sin tener que ingresarlos uno por uno manualmente desde cada pantalla. Puede ser una carga hecha por el equipo de desarrollo directamente, o una función simple dentro de la app; el detalle de cómo se implementa se define en el documento técnico.

### Requerimientos y reglas que cubre
- RF-14
- Sección 8 del documento de requerimientos (Datos iniciales del usuario)

### Depende de
Etapas 2, 3, 4, 7 (necesita que todas las pantallas de carga existan)

### Checklist de verificación
- [ ] Después de la carga, la pantalla de Ingresos muestra exactamente Sueldo y Unicorp con sus montos correctos.
- [ ] Después de la carga, la pantalla de Gastos fijos muestra los 8 conceptos reales con sus montos correctos.
- [ ] Después de la carga, la pantalla de Cuotas muestra las 3 cuotas reales con sus fechas correctas.
- [ ] Después de la carga, el historial de gastos muestra los 4 gastos reales de agosto, todos en la categoría Entretenimiento tal como fueron definidos (sin reclasificar nada).
- [ ] No hace falta reingresar ningún dato manualmente para llegar a este estado.

---

## Etapa 13 — Validación integral contra el caso de prueba

### Qué se construye
Nada nuevo: esta etapa es una revisión completa de la app ya con todos los datos reales cargados, comparando cada número visible contra el caso de prueba oficial del documento de requerimientos (sección 9).

### Requerimientos y reglas que cubre
Todas las reglas de negocio (RN-01 a RN-21) en conjunto.

### Depende de
Todas las etapas anteriores

### Checklist de verificación — Agosto 2026

| Concepto | Valor esperado | Coincide en la app |
|----------|-----------------|---------------------|
| Ingreso mensual total | S/ 3.370,00 | [ ] |
| Gastos fijos | S/ 449,70 | [ ] |
| Cuotas vigentes | S/ 1.213,17 | [ ] |
| Ahorro apartado | S/ 674,00 | [ ] |
| Gastos registrados | S/ 349,00 | [ ] |
| Disponible actual | S/ 684,13 | [ ] |
| Gasto Mensual — presupuesto | S/ 1.685,00 | [ ] |
| Gasto Mensual — gastado | S/ 1.662,87 | [ ] |
| Gasto Mensual — disponible | S/ 22,13 | [ ] |
| Gasto Mensual — % usado | 98,7% | [ ] |
| Entretenimiento — presupuesto | S/ 1.011,00 | [ ] |
| Entretenimiento — gastado | S/ 349,00 | [ ] |
| Entretenimiento — disponible | S/ 662,00 | [ ] |
| Entretenimiento — % usado | 34,5% | [ ] |

Adicionalmente, tras forzar el cierre de agosto:

| Concepto | Valor esperado | Coincide en la app |
|----------|-----------------|---------------------|
| Ahorro apartado del cierre | S/ 674,00 | [ ] |
| Remanente neto de cierre | S/ 684,13 | [ ] |
| Aporte total del periodo | S/ 1.358,13 | [ ] |
| Ahorro acumulado resultante | S/ 1.358,13 | [ ] |

Si todos los puntos de esta tabla coinciden, la **Fase 1 queda cerrada** y la app reemplaza por completo a la hoja de cálculo.

---

## Resumen de dependencias (orden sugerido)

```
Etapa 0 (Fundamentos: Flutter, design system, arquitectura)
   │
Etapa 1 (Base de datos y periodos)
   │
   ├── Etapa 2 (Ingresos)
   ├── Etapa 3 (Gastos fijos)     ← estas tres pueden construirse en paralelo
   └── Etapa 4 (Cuotas)
           │
   Etapa 5 (Motor de cálculo)
           │
   Etapa 6 (Dashboard)
           │
   Etapa 7 (Registrar gasto)
           │
   Etapa 8 (Historial)
           │
   Etapa 9 (Navegación entre periodos)
           │
   Etapa 10 (Cierre de mes)
           │
   Etapa 11 (Ahorro y retiros)
           │
   Etapa 12 (Datos iniciales reales)
           │
   Etapa 13 (Validación final)
```

Nota: la Etapa 12 (carga de datos reales) también podría adelantarse justo después de la Etapa 4, para probar con datos reales desde el Dashboard en vez de datos de prueba inventados. Queda a criterio de cómo se quiera ir verificando en el camino.
