# 🧪 GUÍA DE PRUEBAS Y VALIDACIÓN
## Manual para demostración ante tribunal (Hugo Rodríguez, Tomás Palumbo, Salvador Merayo)

---

## 📌 INSTRUCCIONES PARA EJECUTAR EL SISTEMA

### Paso 1: Iniciar el servidor
```powershell
cd c:\Users\Andrea\Downloads\dml_sgtec_v3
& .\venv\Scripts\Activate.ps1
python app.py
```

El servidor estará disponible en: **http://localhost:5000**

### Paso 2: Credenciales de prueba
```
Usuario: admin
Contraseña: admin123
```

---

## 🔍 PRUEBAS DEMOSTRABLES

### PRUEBA 1: INGRESO RAYPAC
**Objetivo:** Mostrar cómo se ingresa un nuevo equipo desde RAYPAC

**Pasos:**
1. Ir a **http://localhost:5000**
2. Hacer login con `admin` / `admin123`
3. Click en **"RAYPAC" → "Nuevo Ingreso"**
4. Llenar formulario:
   - **Cliente:** Test Cliente
   - **Número de Serie:** SN-2025-001
   - **Modelo:** Máquina XYZ
   - **Tipo Máquina:** Industrial
   - **Comercial:** Test Comercial
   - **Email:** test@example.com
5. Click **"Confirmar"**

**Resultado esperado:**
- ✅ Se crea nuevo ingreso RAYPAC
- ✅ Aparece en listado con número correlativo
- ✅ Se puede editar y agregar remito

---

### PRUEBA 2: REMITO Y FREEZING
**Objetivo:** Mostrar cómo se congela un ingreso RAYPAC

**Pasos:**
1. Desde listado RAYPAC, seleccionar un ingreso
2. Click en **"Agregar Remito"**
3. Ingresar número remito: `RM-2025-001`
4. Click **"Confirmar Envío"**

**Resultado esperado:**
- ✅ Aparece "🔒 FREEZADO" en la ficha
- ✅ Formulario bloqueado (no editable)
- ✅ Se registra en audit log

**Para desfreezar (mostrar seguridad):**
1. Click **"Desfreezar"**
2. Ingresar número de remito: `RM-2025-001`
3. Click **"Desbloquear"**

**Resultado esperado:**
- ✅ Se desbloquea la ficha
- ✅ Vuelve a ser editable

---

### PRUEBA 3: CREAR FICHA DML
**Objetivo:** Mostrar el ingreso de una ficha de reparación

**Pasos:**
1. Desde RAYPAC, click en **"Crear Ficha DML"** en un ingreso
2. Llenar formulario:
   - **Descripción problema:** Máquina no enciende
   - **Diagnóstico inicial:** Revisar motor
   - **Estado:** A LA ESPERA DE REVISIÓN
3. Click **"Crear Ficha"**

**Resultado esperado:**
- ✅ Se crea ficha con número auto-generado (500+)
- ✅ Se genera automáticamente un TICKET
- ✅ Se envía email notificación (si SMTP configurado)

---

### PRUEBA 4: AGREGAR REPUESTOS
**Objetivo:** Mostrar cómo se agregan repuestos a una ficha

**Pasos:**
1. Desde ficha DML, click **"Editar Ficha"**
2. En sección "Agregar Repuesto":
   - **Código:** RBMS0001 (o cualquier código existente)
   - **Cantidad:** 2
3. Click **"Agregar"** (o **"+Agregar"**)

**Resultado esperado:**
- ✅ Repuesto aparece en tabla con verde/rojo según stock
- ✅ Stock se descuenta automáticamente
- ✅ Se puede marcar como "EN FALTA" si no hay

**Validaciones visibles:**
- ✅ Máximo 15 repuestos
- ✅ No permite duplicados (validación JS en tiempo real)
- ✅ Muestra estado del stock

---

### PRUEBA 5: TICKETS AUTOMÁTICOS
**Objetivo:** Mostrar generación automática de tickets

**Pasos:**
1. Ir a **"TICKETS"**
2. Ver lista de tickets generados (uno por cada ficha)
3. Click en un ticket para verlo
4. Ver detalles: Número TK-YYYY-SERIE-00001, estado, cliente

**Resultado esperado:**
- ✅ Ticket con número correlativo único
- ✅ Contiene información de la ficha
- ✅ Permite ver progreso de reparación

**Bonus - Imprimir solapa:**
1. Click **"🖨️ Imprimir Solapa"**
2. Se abre vista optimizada para imprimir

**Resultado esperado:**
- ✅ Formato limpio de 2 copias
- ✅ Barcode simulado
- ✅ Pronto para enviar a cliente

---

### PRUEBA 6: ESTADOS DE REPARACIÓN
**Objetivo:** Mostrar cambio de estados

**Pasos:**
1. Desde ficha DML, click **"Editar"**
2. Cambiar **"Estado Reparación"** entre opciones:
   - A LA ESPERA DE REVISIÓN
   - EN REPARACIÓN
   - A LA ESPERA DE REPUESTOS
   - MÁQUINA LISTA
   - FINALIZADO

**Resultado esperado:**
- ✅ Estados cambian visualmente
- ✅ Se registran cambios en audit log
- ✅ Ticket muestra estado actualizado

---

### PRUEBA 7: 🔒 CERRAR FICHA (CRÍTICO NUEVO)
**Objetivo:** Demostrar cierre y email "Máquina Lista"

**Pasos:**
1. Desde detalle ficha DML, buscar botón **"🔒 Cerrar Ficha"**
2. Click en botón
3. Aparece modal: "¿Deseas FINALIZAR esta ficha?"
4. Click **"Sí, Finalizar"**

**Resultado esperado:**
- ✅ Ficha pasa a estado FINALIZADO
- ✅ is_closed = 1 (bloqueado)
- ✅ Aparece badge "✅ FICHA FINALIZADA"
- ✅ Se intenta enviar email "MÁQUINA LISTA PARA RETIRAR"
- ✅ Se registra en audit log

**Verificación de email:**
- Revisar log en terminal: `Error sending mail: ...` (si no hay SMTP configurado)
- O revisar inbox si SMTP está configurado

---

### PRUEBA 8: STOCK Y ALERTAS
**Objetivo:** Mostrar sistema de alertas

**Pasos:**
1. Ir a **"STOCK"** → **"Ver Listado"**
2. Ver repuestos con colores de alerta:
   - 🔴 **ROJO:** 0 disponibles
   - 🟡 **AMARILLO:** 1 disponible
   - 🟠 **NARANJA:** 2 disponibles
3. Click en cualquier repuesto para ver detalles

**Resultado esperado:**
- ✅ Colores visuales de alerta
- ✅ Se actualiza dinámicamente al agregar/sacar stock

**Para agregar nuevo repuesto:**
1. Click **"Agregar Repuesto"**
2. Llenar datos
3. Password: `ADMIN2024`
4. Click **"Crear"**

**Resultado esperado:**
- ✅ Se crea nuevo repuesto
- ✅ Código asignado automáticamente

---

### PRUEBA 9: ESTADÍSTICAS
**Objetivo:** Mostrar dashboard de estadísticas

**Pasos:**
1. Click en **"Estadísticas"** (navbar)
2. Ver dashboard con:
   - 4 tarjetas de stats (Total Repuestos, En Inventario, Movimientos, Fichas Completadas)
   - Tabla "Repuestos Críticos" (stock ≤2)
   - Tabla "Top 10 Repuestos" más utilizados

**Resultado esperado:**
- ✅ Datos activos y actualizados
- ✅ Visualización clara en tablas
- ✅ Alertas por color para stock bajo

---

### PRUEBA 10: PDF DESCARGABLE
**Objetivo:** Mostrar descarga e impresión de ficha

**Pasos:**
1. Desde ficha DML, click **"📄 Descargar PDF"**
2. Se descarga PDF con nombre: `Ficha_[numero].pdf`
3. Abrir PDF para verificar contenido

**Resultado esperado:**
- ✅ PDF generado correctamente
- ✅ 2 columnas: información + estado equipos
- ✅ Contiene número de ficha, cliente, serie, modelo
- ✅ Tabla de repuestos
- ✅ Estado de componentes
- ✅ Pronto para imprimir

---

### PRUEBA 11: AUDIT LOG
**Objetivo:** Mostrar trazabilidad de cambios

**Pasos:**
1. Ir a **"ADMIN"** → **"Audit Log"**
2. Ver listado de todas las acciones:
   - FREEZE, UNFREEZE (RAYPAC)
   - CREATE, EDIT, CLOSE (DML)
   - ADD, REMOVE (Repuestos)

**Resultado esperado:**
- ✅ Todas las acciones registradas
- ✅ Incluye usuario, fecha, hora, tabla afectada
- ✅ Permite tracking completo

---

### PRUEBA 12: BÚSQUEDA Y FILTROS
**Objetivo:** Mostrar funcionalidad de búsqueda

**Pasos:**
1. Desde listado (RAYPAC, DML, STOCK, etc.)
2. Escribir en buscador (por cliente, serie, código, etc.)
3. Se filtra en tiempo real

**Resultado esperado:**
- ✅ Búsqueda instantánea
- ✅ Filtro funciona correctamente

---

## 📋 TABLA DE DATOS PARA DEMOSTRACIÓN

### Datos de prueba en BD:

**RAYPAC Entries:**
```
ID  Cliente              Serie       Modelo          Comercial
1   Cliente Test 1       SN-2024-001 Máquina XYZ    Juan Perez
2   Cliente Test 2       SN-2024-002 Bomba 500HP    Maria García
3   Cliente Test 3       SN-2024-003 Motor 75kW     Carlos López
4   Cliente Test 4       SN-2024-004 Reductor 10    Ana Rodríguez
5   Cliente Test 5       SN-2024-005 Variador 15    Roberto García
```

**DML Fichas:**
```
ID   Número   Cliente          Estado                          Creada
500  500      Cliente Test 1   A LA ESPERA DE REPUESTOS        2025-12-09
501  501      Cliente Test 2   EN REPARACION                   2025-12-09
502  502      Cliente Test 3   FINALIZADO (is_closed=1)        2025-12-09
503  503      Cliente Test 4   A LA ESPERA DE REVISION         2025-12-09
504  504      Cliente Test 5   EN REPARACION                   2025-12-09
```

**Tickets Generados:**
```
Número                          Ficha   Estado
TK-2025-EQ-2024-0001-00001      500     A LA ESPERA DE REPUESTOS
TK-2025-EQ-2024-0001-00002      501     EN REPARACION
TK-2025-EQ-2024-0001-00003      502     FINALIZADO
TK-2025-EQ-2024-0001-00004      503     A LA ESPERA DE REVISION
TK-2025-EQ-2024-0001-00005      504     EN REPARACION
```

**Stock Disponible:**
```
Código      Nombre              Stock DML   Stock RAYPAC   Alerta
RBMS0001    Rodamiento Bola     5           8              ✓ Normal
RBMS0002    Rodamiento Cónico   0           3              🔴 ROJO
RBMS0003    Sello Mecánico      1           4              🟡 AMARILLO
...
```

---

## ⚙️ CONFIGURACIÓN RECOMENDADA PARA PRESENTACIÓN

### Antes de presentar:
```powershell
# 1. Activar venv
cd c:\Users\Andrea\Downloads\dml_sgtec_v3
& .\venv\Scripts\Activate.ps1

# 2. Iniciar servidor
python app.py

# 3. En navegador
http://localhost:5000
```

### Durante presentación:
- ✅ Mostrar datos de prueba ya cargados
- ✅ Hacer cambios en tiempo real para demostrar funcionalidad
- ✅ Abrir PDF, imprimibles, etc.
- ✅ Explicar cada feature según requisitos especificados

### Posibles preguntas del tribunal:

**P: ¿Cómo se garantiza que máquinas RAYPAC no se envíen antes de tiempo?**
R: Mediante freezing (is_frozen=1) que bloquea edición hasta que se confirma con número_remito

**P: ¿Qué pasa si hay error al enviar?**
R: Se puede desfreezar con número_remito para corregir datos, luego volver a freezar

**P: ¿Cómo se notifica al comercial sobre estado?**
R: Automáticamente por email cuando se crea ticket y cuando ficha está lista ("Máquina Lista")

**P: ¿Máximo de repuestos?**
R: 15 por ficha, validado automáticamente con mensaje de error

**P: ¿Cómo se controla stock?**
R: Dual ubicación (RAYPAC/DML), alertas por color, descuenta automáticamente

**P: ¿Hay registro de quién hizo qué?**
R: Sí, audit log completo con usuario, fecha, hora, acción y tabla afectada

**P: ¿Se puede recuperar si hay error?**
R: Sí, todos los cambios están auditados, se puede rastrear y deshacer si es necesario

---

## 🎥 DEMO RÁPIDA (3 MINUTOS)

```
1. Mostrar login y dashboard
2. RAYPAC: Crear nuevo ingreso → Agregar remito → Freezear
3. DML: Ver ficha → Agregar repuesto → Cambiar estado
4. Tickets: Mostrar ticket generado → Imprimir solapa
5. Stock: Ver alertas de color → Estadísticas
6. Cerrar ficha: Botón → Modal → Email notificación
7. PDF: Descargar y mostrar
8. Audit: Mostrar log de cambios
```

**Tiempo aproximado:** 3 minutos mostrando todas las features principales

---

## ✅ CHECKLIST ANTES DE PRESENTAR

- [ ] Servidor Flask ejecutándose
- [ ] Base de datos con datos de prueba
- [ ] Navegador abierto en http://localhost:5000
- [ ] Credenciales (admin/admin123) probadas
- [ ] Email SMTP configurado (opcional, funciona sin él)
- [ ] Printer disponible (para demostración de print)
- [ ] Conexión a internet (para CDN Bootstrap si es necesario)
- [ ] PDF reader disponible (para abrir descargados)

---

**Listo para demostración ante tribunal.**
