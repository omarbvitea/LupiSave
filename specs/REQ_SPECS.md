# Documento de Requerimientos
## App de Presupuesto Personal — Método 50/30/20

**Versión:** 3.0  
**Estado:** Alcance de Fase 1 cerrado y aprobado  
**Tecnología:** Flutter

---

## 1. Resumen ejecutivo

### Problema
El usuario gestiona su presupuesto personal en una hoja de cálculo. Esto obliga a estar frente a una computadora para registrar cualquier gasto, y consultar el estado del mes requiere manipular selectores manualmente. En la práctica, los gastos se registran tarde o no se registran.

### Solución
Una aplicación móvil que aplica el método 50/30/20, con dos objetivos centrales: registrar un gasto en menos de diez segundos, y responder de inmediato a la pregunta "¿cuánto me queda disponible este mes?".

### Métrica de éxito
El usuario registra al menos el 90% de sus gastos del mes en la app, y confía en el saldo disponible sin verificarlo en otra herramienta.

### Usuario objetivo
- Una sola persona, uso personal
- Moneda: Soles peruanos (S/)
- Idioma: español

### Alcance V1
Flujo completo de presupuesto personal mensual más gestión del ahorro acumulado. Sin integración bancaria, sin multiusuario, sin multi-moneda.

---

## 2. Conceptos del dominio

**Periodo**  
Un mes calendario, del día 1 al último día. Todo cálculo se evalúa contra un periodo. Por defecto, el mes actual.

**Ingreso**  
Fuente recurrente de dinero mensual. Valor fijo que el usuario edita cuando su situación cambia; no se captura mes a mes.

**Gasto fijo**  
Pago recurrente sin fecha de término.

**Cuota temporal**  
Pago recurrente con fecha de inicio y fin. Solo cuenta en los meses dentro de su rango.

**Gasto registrado**  
Consumo puntual anotado manualmente por el usuario.

**Sobre de gasto**  
Una de las dos bolsas contra las que se consume dinero:

| Sobre | % del ingreso | Qué consume |
|-------|---------------|------------|
| Gasto Mensual | 50% | Gastos fijos + cuotas temporales + gastos registrados de esta categoría |
| Entretenimiento | 30% | Únicamente gastos registrados de esta categoría |

**Ahorro apartado**  
El 20% del ingreso, reservado automáticamente al inicio del periodo. No es un sobre de gasto y no puede consumirse registrando gastos.

**Ahorro acumulado**  
Saldo persistente que refleja el dinero realmente ahorrado. Aumenta con el apartado mensual y con el remanente de cierre; disminuye con los retiros que el usuario registre.

**Retiro de ahorro**  
Acción explícita mediante la cual el usuario saca dinero del ahorro acumulado, dejando constancia de cuándo, cuánto y por qué.

---

## 3. Modelo de datos

### 3.1 Ingreso

| Campo | Tipo | Reglas |
|-------|------|--------|
| Identificador | Único | Generado por el sistema |
| Fuente | Texto (máx. 40) | Obligatorio |
| Monto mensual | Decimal, 2 decimales | Obligatorio, mayor que cero. Editable en cualquier momento |
| Activo | Booleano | Permite pausar sin eliminar el historial |

### 3.2 Gasto fijo

| Campo | Tipo | Reglas |
|-------|------|--------|
| Identificador | Único | Generado por el sistema |
| Concepto | Texto (máx. 40) | Obligatorio |
| Monto mensual | Decimal, 2 decimales | Obligatorio, mayor que cero |
| Activo | Booleano | Un gasto inactivo deja de contar |

### 3.3 Cuota temporal

| Campo | Tipo | Reglas |
|-------|------|--------|
| Identificador | Único | Generado por el sistema |
| Concepto | Texto (máx. 40) | Obligatorio |
| Cuota mensual | Decimal, 2 decimales | Obligatorio, mayor que cero |
| Fecha de inicio | Fecha | Obligatoria. Se normaliza al primer día de su mes |
| Fecha de fin | Fecha | Obligatoria. Igual o posterior a la fecha de inicio |
| Cuotas totales / pagadas | Entero | Opcional. Permite mostrar progreso ("cuota 3 de 12") |

### 3.4 Gasto registrado

| Campo | Tipo | Reglas |
|-------|------|--------|
| Identificador | Único | Generado por el sistema |
| Fecha | Fecha | Obligatoria. Por defecto: hoy |
| Categoría | Enumeración de dos valores | Obligatoria: Gasto Mensual o Entretenimiento. "Ahorro" no es un valor válido |
| Descripción | Texto (máx. 60) | Opcional |
| Monto | Decimal, 2 decimales | Obligatorio, mayor que cero |

### 3.5 Configuración de presupuesto

| Campo | Tipo | Valor por defecto |
|-------|------|-------------------|
| Porcentaje Gasto Mensual | Porcentaje | 50% |
| Porcentaje Entretenimiento | Porcentaje | 30% |
| Porcentaje Ahorro | Porcentaje | 20% |
| Moneda | Texto | S/ |

Los tres porcentajes deben sumar exactamente 100%.

### 3.6 Cierre de periodo

Registro generado automáticamente por el sistema al cerrar cada mes.

| Campo | Tipo | Reglas |
|-------|------|--------|
| Periodo | Mes y año | Único por periodo |
| Ahorro apartado | Decimal | El 20% del ingreso de ese periodo |
| Remanente neto transferido | Decimal | Suma algebraica de los saldos de los sobres. Puede ser negativo |
| Aporte total del periodo | Decimal | Ahorro apartado más remanente neto |
| Saldo acumulado resultante | Decimal | Saldo del ahorro tras aplicar el cierre |

### 3.7 Retiro de ahorro (nuevo)

| Campo | Tipo | Reglas |
|-------|------|--------|
| Identificador | Único | Generado por el sistema |
| Fecha | Fecha | Obligatoria. Por defecto: hoy |
| Monto | Decimal, 2 decimales | Obligatorio, mayor que cero |
| Motivo | Texto (máx. 60) | Opcional pero recomendado |

---

## 4. Reglas de negocio

**RN-01 — Ingreso mensual total**  
Suma de los montos de todos los ingresos activos.

**RN-02 — Gastos fijos del mes**  
Suma de los montos de todos los gastos fijos activos. No depende del periodo.

**RN-03 — Cuotas vigentes del mes**  
Suma de las cuotas mensuales de aquellas cuotas cuyo rango se superpone con el periodo: inicio anterior o igual al fin del periodo, y fin posterior o igual al inicio del periodo.

**RN-04 — Ahorro apartado**  
Ingreso mensual total por el porcentaje de ahorro. Se descuenta antes de cualquier cálculo de disponibilidad.

**RN-05 — Presupuesto de cada sobre**  
Ingreso mensual total por el porcentaje del sobre.

**RN-06 — Imputación de compromisos fijos**  
La totalidad de los gastos fijos y de las cuotas vigentes se carga al sobre Gasto Mensual. Entretenimiento no recibe imputación automática.

**RN-07 — Gasto registrado por sobre**  
Suma de los gastos cuya fecha cae en el periodo y cuya categoría corresponde al sobre.

**RN-08 — Total gastado por sobre**  
Lo imputado por RN-06 más lo registrado por RN-07.

**RN-09 — Disponible por sobre**  
Presupuesto menos total gastado. Puede ser negativo; el sistema lo señala pero no lo bloquea.

**RN-10 — Porcentaje de uso por sobre**  
Total gastado entre presupuesto. Si el presupuesto es cero, el resultado es cero.

**RN-11 — Disponible actual (indicador principal)**  
Ingreso mensual total, menos gastos fijos, menos cuotas vigentes, menos ahorro apartado, menos todos los gastos registrados del periodo.

**RN-12 — Validación de porcentajes**  
No se permite guardar una configuración cuyos porcentajes no sumen exactamente 100%.

**RN-13 — Vigencia automática de cuotas**  
Una cuota deja de contar por sí sola cuando el periodo supera su fecha de fin.

**RN-14 — Historicidad**  
Los gastos registrados no se recalculan retroactivamente al modificar ingresos, gastos fijos o porcentajes.

**RN-15 — El ahorro no es gastable**  
La categoría "Ahorro" no existe al registrar un gasto. El ahorro solo se modifica por el apartado automático (RN-04), la transferencia de cierre (RN-16) y los retiros explícitos (RN-19).

**RN-16 — Cierre de mes y transferencia neta**  
Al finalizar un periodo se calcula el neto de los saldos de ambos sobres —sumando positivos y restando negativos— y ese neto se transfiere al ahorro acumulado junto con el apartado del mes. Los sobres del nuevo periodo arrancan siempre desde su presupuesto completo, sin arrastre. Ejemplo: Gasto Mensual −S/ 150 y Entretenimiento +S/ 400 producen una transferencia de S/ 250.

**RN-17 — Neto de cierre negativo**  
Si el neto resulta negativo, el sobregiro se descuenta del ahorro acumulado. El saldo acumulado puede disminuir en un mes de exceso, reflejando la realidad de que el gasto salió de algún lado.

**RN-18 — Ahorro acumulado**  
Es la suma de todos los ahorros apartados, más todos los netos transferidos por RN-16, menos todos los retiros registrados. Es un saldo persistente e independiente del periodo consultado.

**RN-19 — Retiro de ahorro** (nueva)  
El usuario puede registrar un retiro que reduce el ahorro acumulado. Todo retiro queda en un historial permanente con fecha, monto y motivo. Un retiro no es un gasto: no consume ningún sobre ni afecta el disponible del mes.

**RN-20 — Ingreso fijo y editable**  
El ingreso no se captura por periodo. Es configuración que aplica a todos los periodos hasta que el usuario la modifique. Los periodos ya cerrados conservan los valores con los que cerraron.

**RN-21 — La categoría la decide el usuario** (nueva)  
El sistema no infiere, sugiere ni reclasifica categorías. Si el usuario clasifica un gasto de una forma determinada, esa clasificación es la correcta y se respeta sin advertencias. No habrá categorización automática ni por palabras clave en ninguna fase.

**RN-22 — Proporciones de ahorro configurables y datadas** (nueva)  
Los porcentajes de los sobres y del ahorro (por defecto 50/30/20) son configurables. Un cambio rige **desde** el periodo en que se aplica hacia adelante y no altera meses anteriores: cada periodo usa el método vigente con la clave `"YYYY-MM"` más alta que sea menor o igual a la suya, y cada mes se cierra con el método vigente a su fin (RN-14, RN-16). Toda configuración debe cumplir RN-12.

**RN-23 — Los meses pasados son de solo lectura** (nueva)  
Todo registro con fecha propia (gasto, cuota) solo puede crearse, editarse o eliminarse si su periodo es el **mes en curso o uno futuro**. La comparación es por mes: estando a 20 de agosto se puede editar o borrar un gasto del 1 de agosto, pero no uno de julio. Concretamente: los selectores de fecha parten del primer día del mes en curso, un gasto de un periodo pasado no se edita ni se elimina, y una cuota **finalizada** (su fin ya pasó) queda de solo lectura. Los ingresos y gastos fijos son configuración recurrente sin mes propio (RN-20), así que esta regla no aplica sobre ellos.

---

## 5. Pantallas

### P1 · Inicio / Dashboard — Prioridad 0
- Selector de periodo navegable mes a mes en ambas direcciones.
- Tarjeta principal: Disponible Actual (RN-11), en color positivo o de alerta según el signo.
- Dos tarjetas de sobre (Gasto Mensual, Entretenimiento) con presupuesto, gastado, disponible y barra de progreso.
- Tarjeta de ahorro, visualmente distinta: apartado del mes y acumulado total. Sin barra de progreso, porque no se consume. Enlaza a P7.
- Resumen secundario: ingreso, gastos fijos, cuotas vigentes.
- Botón de acción flotante para registrar un gasto.

### P2 · Registrar gasto — Prioridad 0
Modal optimizado para velocidad. Orden: monto (teclado numérico grande, con foco al abrir) → categoría (dos opciones visibles, sin desplegable) → descripción (opcional) → fecha (preseleccionada en hoy). Al guardar, cierra y vuelve al dashboard actualizado. Sin sugerencias ni autoclasificación (RN-21).

### P3 · Historial de gastos — Prioridad 0
Lista agrupada por fecha, con filtros por periodo y categoría, total del filtro arriba, búsqueda por descripción, y acciones de editar y eliminar.

### P4 · Gastos fijos — Prioridad 0
Lista con total al pie. Alta, edición, eliminación y activación/desactivación.

### P5 · Cuotas temporales — Prioridad 0
Lista con concepto, cuota mensual, rango de fechas y estado calculado (Vigente, Futura, Finalizada). Meses restantes. Total vigente del periodo al pie.

### P6 · Ingresos — Prioridad 0
Lista de fuentes con total. Alta, edición, eliminación y activación/desactivación.

### P7 · Ahorro — Prioridad 0 (promovida al MVP)
Sección dedicada, con tres bloques:
- Saldo acumulado total, destacado como cifra principal.
- Historial de aportes mes a mes: para cada periodo cerrado, cuánto se apartó por el 20%, cuánto fue el remanente neto de cierre, y el total aportado ese mes. Los meses con neto negativo se muestran diferenciados.
- Historial de retiros: fecha, monto y motivo de cada retiro, en orden cronológico inverso.
- Incluye la acción de registrar un retiro.

### P8 · Ajustes — Prioridad 1
Edición de los tres porcentajes con validación en vivo, moneda, exportación e importación, respaldos y bloqueo de seguridad.

---

## 6. Requerimientos funcionales

| ID | Requerimiento | Criterio de aceptación | Prio |
|----|--------------|-----------------------|------|
| RF-01 | Registrar un gasto | Con monto válido y una de las dos categorías, al guardar aparece en el historial y el dashboard se actualiza sin recargar | 0 |
| RF-02 | Editar o eliminar un gasto | La eliminación pide confirmación; al confirmar, los totales se recalculan de inmediato | 0 |
| RF-03 | Navegar entre periodos | Cualquier mes pasado o futuro; RN-03 y RN-07 a RN-11 se reevalúan | 0 |
| RF-04 | Consultar disponible actual | Refleja exactamente RN-11 y cambia de color cuando es negativo | 0 |
| RF-05 | Gestionar gastos fijos | Alta, edición, eliminación y desactivación | 0 |
| RF-06 | Gestionar cuotas temporales | Alta, edición y eliminación, validando que el fin no sea anterior al inicio | 0 |
| RF-07 | Gestionar ingresos | Alta, edición, eliminación y desactivación | 0 |
| RF-08 | Consultar el ahorro | El saldo mostrado equivale a RN-18 y se detalla el aporte de cada mes cerrado | 0 |
| RF-09 | Registrar un retiro de ahorro | Con monto válido, el retiro reduce el acumulado y aparece en el historial. No afecta el disponible del mes | 0 |
| RF-10 | Consultar historial de retiros | Lista cronológica con fecha, monto y motivo de cada retiro | 0 |
| RF-11 | Cerrar mes automáticamente | Al primer acceso tras terminar un periodo, el sistema ejecuta RN-16 y RN-17 sin intervención y deja constancia en el historial de ahorro | 0 |
| RF-12 | Configurar porcentajes | Editables; guardado bloqueado si no suman 100% | 1 |
| RF-13 | Alertar sobregiro | Notificación al superar el 80% y nuevamente al superar el 100% del presupuesto de un sobre | 1 |
| RF-14 | Importar datos iniciales | En la primera apertura, la app permite cargar el conjunto de datos iniciales | 1 |
| RF-15 | Exportar datos | Archivo con ingresos, gastos fijos, cuotas, gastos, cierres y retiros en formato tabular estándar | 2 |
| RF-16 | Recordatorio diario | Notificación a hora configurable invitando a registrar los gastos del día | 2 |
| RF-17 | Ver tendencia histórica | Gráfico de gasto mensual de los últimos seis periodos contra su presupuesto, y evolución del ahorro acumulado | 2 |

---

## 7. Requerimientos no funcionales

| ID | Requerimiento | Detalle |
|----|--------------|---------| 
| RNF-01 | Funcionamiento sin conexión | Opera al 100% sin internet. Almacenamiento local en el dispositivo |
| RNF-02 | Velocidad de registro | Máximo tres interacciones, menos de diez segundos |
| RNF-03 | Rendimiento | Dashboard en menos de un segundo con hasta 5.000 gastos históricos |
| RNF-04 | Precisión monetaria | Dos decimales y redondeo consistente. Separador de miles y símbolo de moneda siempre visibles |
| RNF-05 | Localización | Español, fechas día/mes/año, meses con nombre completo en español |
| RNF-06 | Respaldo y portabilidad | Exportación bajo demanda y respaldo local periódico. Ningún dato se pierde tras reinstalar si existe respaldo |
| RNF-07 | Privacidad | Datos solo en el dispositivo. Bloqueo opcional por biometría o código |
| RNF-08 | Plataforma | Flutter, una sola base de código para iOS y Android |
| RNF-09 | Usabilidad con una mano | Registrar gasto y cambiar de mes alcanzables con el pulgar |
| RNF-10 | Integridad del cierre | El cierre de mes es idempotente: ejecutarlo dos veces para el mismo periodo no duplica la transferencia |
| RNF-11 | Trazabilidad del ahorro | Todo movimiento del ahorro acumulado —apartado, cierre o retiro— debe ser reconstruible desde el historial. El saldo nunca es un número sin origen |

---

## 8. Datos iniciales del usuario

### Ingresos
**Total mensual: S/ 3.370,00**

| Fuente | Monto |
|--------|-------|
| Sueldo | S/ 1.370,00 |
| Unicorp | S/ 2.000,00 |

### Gastos fijos
**Total mensual: S/ 449,70**

| Concepto | Monto |
|----------|-------|
| Chatgpt | S/ 19,90 |
| Icloud | S/ 3,90 |
| YT Premium | S/ 10,00 |
| Claude | S/ 80,00 |
| Cupo | S/ 200,00 |
| Movistar | S/ 35,90 |
| Warda | S/ 50,00 |
| Win | S/ 50,00 |

### Cuotas temporales

| Concepto | Cuota mensual | Desde | Hasta |
|----------|---------------|-------|-------|
| Monitor OLED | S/ 653,70 | Septiembre 2026 | Noviembre 2026 |
| Baldo celular | S/ 446,67 | Agosto 2026 | Septiembre 2026 |
| Macbook | S/ 766,50 | Agosto 2026 | Diciembre 2026 |

**Vigente en agosto 2026: S/ 1.213,17**

### Gastos registrados (agosto 2026)
**Total: S/ 349,00**

| Fecha | Categoría | Descripción | Monto |
|-------|-----------|-------------|-------|
| 01/08/2026 | Entretenimiento | Gasolina | S/ 50,00 |
| 01/08/2026 | Entretenimiento | Chifa CC | S/ 15,00 |
| 03/08/2026 | Entretenimiento | Pichanga | S/ 9,00 |
| 06/08/2026 | Entretenimiento | Comida y ropa | S/ 275,00 |

> Se cargan tal cual están, sin reclasificar. Conforme a RN-21, la categoría que asignó el usuario es la correcta.

### Configuración
Gasto Mensual 50% · Entretenimiento 30% · Ahorro 20%

---

## 9. Caso de prueba — Agosto 2026

| Concepto | Valor esperado |
|----------|----------------|
| Ingreso mensual total | S/ 3.370,00 |
| Gastos fijos | S/ 449,70 |
| Cuotas vigentes | S/ 1.213,17 |
| Ahorro apartado | S/ 674,00 |
| Gastos registrados | S/ 349,00 |
| **Disponible actual** | **S/ 684,13** |

### Sobres

| Sobre | Presupuesto | Gastado | Disponible | % usado |
|-------|------------|---------|-----------|---------|
| Gasto Mensual | S/ 1.685,00 | S/ 1.662,87 | S/ 22,13 | 98,7% |
| Entretenimiento | S/ 1.011,00 | S/ 349,00 | S/ 662,00 | 34,5% |

### Al cerrar agosto 2026

| Movimiento | Monto |
|------------|-------|
| Ahorro apartado (20%) | S/ 674,00 |
| Remanente neto de cierre (22,13 + 662,00) | S/ 684,13 |
| Aporte total del periodo | S/ 1.358,13 |
| Ahorro acumulado resultante (si es el primer mes) | S/ 1.358,13 |

---

## 10. Roadmap

### Fase 1 — Producto mínimo viable
Pantallas P1 a P7, requerimientos RF-01 a RF-11, todas las reglas RN-01 a RN-21, carga de datos iniciales y funcionamiento sin conexión. Al terminar, la app reemplaza por completo a la hoja de cálculo y además aporta la gestión de ahorro que hoy no existe.

### Fase 2 — Control y configuración
Pantalla P8, requerimientos RF-12 a RF-14. Alertas de sobregiro y porcentajes configurables.

### Fase 3 — Análisis y comodidad
Requerimientos RF-15 a RF-17. Tendencias históricas, exportación y widget de pantalla de inicio.

### Fase 4 — A evaluar
Sincronización entre dispositivos, subcategorías dentro de cada sobre, y metas de ahorro con seguimiento.

---

## 11. Fuera de alcance de la versión 1
- Integración con bancos
- Múltiples usuarios
- Múltiples monedas
- Escaneo de recibos
- Gestión de deudas y préstamos
- Inversiones
- Reportes fiscales
- Subcategorías dentro de los sobres
- Cualquier forma de categorización automática o sugerida (excluida permanentemente por RN-21)

---

## 12. Registro de decisiones

| # | Decisión | Regla asociada |
|---|----------|----------------|
| D-01 | Dos categorías al registrar: Gasto Mensual y Entretenimiento. Sin subcategorías en el MVP | — |
| D-02 | El ahorro se aparta, no se registra como gasto | RN-15 |
| D-03 | Gastos fijos, cuotas y gastos mensuales nuevos consumen el sobre del 50%. Un margen ajustado es responsabilidad del usuario | RN-06 |
| D-04 | Ingreso fijo y editable, no capturado por periodo | RN-20 |
| D-05 | Flutter, base de código única para iOS y Android | RNF-08 |
| D-06 | El remanente se transfiere al ahorro al cerrar el mes; los sobres no acumulan saldo | RN-16 |
| D-07 | Se transfiere el neto de ambos sobres. Si el neto es negativo, se descuenta del acumulado | RN-16, RN-17 |
| D-08 | Sección dedicada de ahorro con saldo total, aportes mes a mes e historial de retiros | RN-18, RN-19 · P7 · RF-08 a RF-10 |
| D-09 | La categoría la decide el usuario; el sistema nunca reclasifica ni sugiere | RN-21 |

> **No quedan decisiones abiertas. El alcance de la Fase 1 está cerrado.**
