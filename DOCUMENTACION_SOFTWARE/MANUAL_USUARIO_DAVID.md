# Manual de Usuario - Sistema DML ST & Gestión de Repuestos

**Para:** David (Gestor de Pruebas)  
**Versión:** 1.0  
**Fecha:** 9 de Diciembre de 2025

---

## 📋 TABLA DE CONTENIDOS

1. [Acceso al Sistema](#acceso)
2. [Roles y Permisos](#roles)
3. [Flujo Completo](#flujo)
4. [Gestión de Stock](#stock)
5. [Fichas de Reparación y Tickets](#fichas)
6. [Envío de Repuestos](#envios)
7. [Estadísticas y Reportes](#estadisticas)
8. [Datos de Prueba](#prueba)
9. [Troubleshooting](#troubleshooting)

---

## <a name="acceso"></a> 1. ACCESO AL SISTEMA

### URLs
- **Local:** `http://localhost:5000`
- **Producción:** (será configurada en Render/Railway)

### Usuarios de Prueba

| Email | Contraseña | Rol | Ubicación | Acceso |
|-------|-----------|-----|-----------|--------|
| **admin@dml.local** | admin | ADMIN | Ambas | ✅ Sistema completo + gestión usuarios |
| **raypac@dml.local** | raypac | RAYPAC | RAYPAC | ✅ Equipos + stock RAYPAC + envíos |
| **tecnico@dml.local** | tecnico | DML_ST | DML | ✅ Fichas + tickets + reparación |
| **repuestos@dml.local** | repuestos | DML_REPUESTOS | DML | ✅ Stock DML + envíos recibidos + estadísticas |

**Nota:** Las contraseñas de prueba son simples para testing. Cambiar antes de producción.

---

## <a name="roles"></a> 2. ROLES Y PERMISOS

### 🟦 ADMIN (admin@dml.local)
- Acceso completo a todas las funcionalidades
- Ver stock RAYPAC y DML simultáneamente
- Gestión de usuarios (crear, editar, cambiar roles, desactivar)
- Estadísticas consolidadas
- Modificaciones de seguridad requieren contraseña adicional

### 🟨 RAYPAC (raypac@dml.local)
**Responsable:** Recepción de equipos y gestión de stock de repuestos importados

| Función | Acceso |
|---------|--------|
| Ver equipos ingresados | ✅ Solo RAYPAC |
| Ingresar nuevo equipo | ✅ |
| Agregar remito y freezar ingreso | ✅ |
| Ver stock RAYPAC | ✅ |
| Agregar/editar repuestos RAYPAC | ✅ |
| Enviar repuestos a DML | ✅ |
| Ver fichas DML | ❌ |
| Ver stock DML | ❌ |

### 🟩 DML_REPUESTOS (repuestos@dml.local)
**Responsable:** Gestión de stock local y recepción de repuestos de RAYPAC

| Función | Acceso |
|---------|--------|
| Ver stock DML | ✅ |
| Agregar/editar repuestos DML | ✅ |
| Recibir envíos de RAYPAC | ✅ |
| Ver estadísticas de uso | ✅ |
| Ver fichas (referencia) | ✅ Solo lectura |
| Ver stock RAYPAC | ❌ |
| Crear fichas | ❌ |

### 🟦 DML_ST (tecnico@dml.local)
**Responsable:** Reparación de equipos y registro de avances

| Función | Acceso |
|---------|--------|
| Ver fichas DML | ✅ |
| Crear nueva ficha | ✅ |
| Registrar diagnóstico | ✅ |
| Cambiar estado de reparación | ✅ |
| Agregar repuestos a ficha | ✅ |
| Marcar faltantes | ✅ |
| Generar/ver tickets | ✅ |
| Ver stock DML (referencia) | ✅ Solo lectura |
| Editar stock | ❌ |

---

## <a name="flujo"></a> 3. FLUJO COMPLETO DE FUNCIONAMIENTO

### 3.1 INGRESO DE EQUIPO EN RAYPAC

**Quién lo hace:** Usuario RAYPAC  
**Dónde:** Menú RAYPAC → "Listar/Ingresar"

**Pasos:**
1. Click en **"Nuevo ingreso"**
2. Completar campos obligatorios:
   - **Cliente:** Nombre de la empresa
   - **Número de serie:** Código único del equipo
   - **Modelo de máquina:** Ej. "Validador", "Selladora"
   - **Tipo de máquina:** Ej. "A BATERÍA", "110V"
   - **Comercial:** Nombre del vendedor/responsable
   - **Email comercial:** Contacto del comercial
3. Campos opcionales:
   - Número de batería
   - Número de cargador
   - Diagnóstico inicial
4. Click **"Guardar ingreso"**

**Estado del ingreso:** EDITABLE (puede modificarse)

---

### 3.2 DESPACHO A DML (Freezar Ingreso)

**Quién lo hace:** Usuario RAYPAC  
**Dónde:** Vista del ingreso en RAYPAC

**Pasos:**
1. Ir a la ficha del ingreso (click en el número)
2. Cuando se despacha la máquina a DML:
   - Ingresar **"Número de remito"** (ej. RM-2024-001)
   - Click en **"Confirmar envío"**
3. El ingreso se **FREEZA** (queda protegido, no se puede editar)
4. Se genera automáticamente una **Ficha en DML** listos para reparar
5. Email notifica a DML_ST sobre nuevo ingreso

**Estado del ingreso:** FREEZADO (solo admin puede descongelar)

---

### 3.3 CREACIÓN DE FICHA EN DML

**Quién lo hace:** Usuario DML_ST  
**Dónde:** Menú Fichas ST → "Lista de Fichas"

**Casos:**
- **Opción A - Automático:** Si el ingreso RAYPAC está freezado, se crea automáticamente
- **Opción B - Manual:** Usuario DML_ST puede crear ficha nueva sin RAYPAC

**Pasos (creación manual):**
1. Click **"Nueva Ficha"**
2. Seleccionar **Ingreso RAYPAC** (si existe) o dejar en blanco
3. Completar datos obligatorios:
   - **Técnico asignado:** Quién hará la reparación
   - **Diagnóstico inicial:** Qué se observa
4. Campos opcionales:
   - Observaciones iniciales
5. Click **"Guardar"**

**Resultado automático:**
- ✅ Se crea **Ficha única** con número correlativo (Ej. #501)
- ✅ Se genera **Ticket automático** (Ej. TK-2025-EQ-2024-001-00002)
- ✅ Se envía email con datos del ticket
- ✅ Estado inicial: **A LA ESPERA DE REVISIÓN**

---

### 3.4 REPARACIÓN EN DML (Trabajo del Técnico)

**Quién lo hace:** Usuario DML_ST  
**Dónde:** Vista de la ficha en Fichas ST

#### 3.4.1 CAMBIO DE ESTADOS

Secuencia recomendada:

```
A LA ESPERA DE REVISIÓN
         ↓ [Técnico examina]
EN REPARACIÓN
         ↓ [Si faltan repuestos]
A LA ESPERA DE REPUESTOS
         ↓ [Repuestos llegan]
EN REPARACIÓN (nuevamente)
         ↓ [Reparación finalizada]
MÁQUINA LISTA PARA RETIRAR
         ↓ [Cliente retira]
MÁQUINA ENTREGADA
```

**Cómo cambiar estado:**
1. En la ficha, click en el campo "Estado de reparación"
2. Seleccionar nuevo estado de la lista
3. Click **"Guardar cambios"**

#### 3.4.2 REGISTRO DE REPUESTOS UTILIZADOS

**En la ficha:** Sección "Repuestos utilizados"

**Pasos:**
1. Click **"Agregar repuesto"**
2. Buscar repuesto por código o descripción
3. Ingresar **cantidad utilizada**
4. Seleccionar **proveedor:** "DML (Local)" o "RAYPAC" (si fue enviado)
5. Click **"Agregar"** (se descuenta automáticamente del stock DML)
6. Si no hay stock: Estado pasa a **"EN FALTA"** y se notifica a repuestos@dml.local

**Validaciones:**
- ✅ Máximo 15 repuestos por ficha
- ✅ Stock DML se descuenta automáticamente
- ✅ Estadísticas de uso se actualizan
- ✅ Alertas si stock baja a ≤2

#### 3.4.3 GESTIÓN DE FALTANTES

Si falta un repuesto:
1. En la ficha: marcar **"EN FALTA"**
2. Notificación automática a repuestos@dml.local
3. DML_REPUESTOS verá la ficha en estado "esperando repuestos"
4. Una vez que RAYPAC envía el repuesto:
   - DML_REPUESTOS recibe y confirma
   - Stock DML actualiza
   - Cambiar ficha a "EN REPARACIÓN" nuevamente

#### 3.4.4 CIERRE Y ENTREGA

**Cuando el equipo está listo:**
1. Cambiar estado a **"MÁQUINA LISTA PARA RETIRAR"**
2. Ingresar diagnóstico final (qué se reparó)
3. Ingresar número de ciclos (si aplica)
4. Click **"Guardar"**

**Para entregar:**
1. Cambiar estado a **"MÁQUINA ENTREGADA"**
2. Fecha de egreso se registra automáticamente
3. Ficha queda cerrada (no se puede editar)

#### 3.4.5 GENERAR PDF DE FICHA

**Dónde:** En la vista de ficha, botón **"Descargar PDF"**

El PDF contiene:
- Datos del ingreso RAYPAC
- Número de ficha y ticket
- Diagnóstico inicial y final
- Repuestos utilizados
- Estados de reparación
- Fecha de egreso

---

## <a name="stock"></a> 4. GESTIÓN DE STOCK

### 4.1 STOCK POR UBICACIÓN

El sistema maneja **2 ubicaciones independientes**:

| Ubicación | Gestiona | Responsable |
|-----------|----------|-------------|
| **RAYPAC** | Stock de repuestos importados | RAYPAC |
| **DML** | Stock local para reparaciones | DML_REPUESTOS |

**Acceso:**
- **RAYPAC:** Solo ve su stock
- **DML_REPUESTOS:** Solo ve su stock
- **ADMIN:** Ve ambas ubicaciones (botones RAYPAC/DML)

### 4.2 AGREGAR NUEVO REPUESTO

**Quién:** RAYPAC (en RAYPAC) o DML_REPUESTOS (en DML)  
**Dónde:** Menú Stock → Botón **"+ Nuevo Repuesto"**

**Pasos:**
1. Click **"+ Nuevo Repuesto"**
2. Completar:
   - **Código (SKU):** Identificador único (Ej. A000001)
   - **Descripción:** Nombre del repuesto (Ej. "Correa de transmisión")
   - **Cantidad inicial:** Stock disponible
3. Click **"Guardar"**

### 4.3 BUSCAR REPUESTOS

**En la página de Stock:**

- **Por código:** Escribir código en la caja de búsqueda
- **Por descripción:** Escribir descripción en la caja
- **Búsqueda en tiempo real:** Se filtra automáticamente
- **Botón "Limpiar":** Resetea filtros

### 4.4 EDITAR STOCK

**Dónde:** Página de Stock, click en el repuesto

**Acciones permitidas:**
- Cambiar cantidad (si no es ADMIN, el botón requiere confirmación)
- Editar descripción
- Ver histórico de cambios

**ADMIN requiere contraseña:** Para agregar/eliminar repuestos o modificaciones de seguridad

### 4.5 ALERTAS DE STOCK AUTOMÁTICAS

El sistema calcula alertas **por ubicación**:

| Cantidad | Alerta | Color | Símbolo |
|----------|--------|-------|---------|
| 0 | AGOTADO | 🔴 Rojo | ⭕ |
| 1 | ÚLTIMO | 🟡 Amarillo | ⚠️ |
| 2 | CRÍTICO | 🟠 Naranja | ⚠️ |
| >2 | OK | 🟢 Verde | ✓ |

**Las alertas se actualizan automáticamente cuando:**
- Se usan repuestos en fichas DML
- Se recepciona envío de RAYPAC a DML
- Se edita manualmente el stock

**Notificaciones:**
- Email a repuestos@dml.local si stock baja a ≤2
- Alerta visual en el dashboard

---

## <a name="envios"></a> 5. ENVÍO DE REPUESTOS

### 5.1 RAYPAC ENVÍA REPUESTOS A DML

**Quién:** Usuario RAYPAC  
**Dónde:** Menú Envíos → Botón **"Nuevo envío"**

**Pasos:**
1. Click **"Nuevo envío"**
2. Seleccionar repuestos:
   - Buscar por código
   - Ingresar cantidad a enviar
   - Click **"Agregar"** (máximo 10 repuestos por envío)
3. Ingresar **"Número de remito"** (Ej. RP-2024-00100)
4. Click **"Confirmar envío"**

**Resultado:**
- ✅ Stock **descuenta automáticamente en RAYPAC**
- ✅ Envío queda en estado **"PENDIENTE"** (esperando confirmación de DML)
- ✅ Email notifica a repuestos@dml.local
- ✅ Se genera número de envío único (Ej. RP-2024-00100)

---

### 5.2 DML RECIBE REPUESTOS

**Quién:** Usuario DML_REPUESTOS  
**Dónde:** Menú Envíos → Lista de envíos pendientes

**Pasos:**
1. Ver envío en estado **"PENDIENTE"**
2. Verificar repuestos recibidos
3. Si alguno falta:
   - Marcar en **"Repuestos faltantes"**
   - Notificación automática a RAYPAC
   - Se carga solo lo recibido
4. Click **"Confirmar recepción"**

**Resultado:**
- ✅ Stock **suma automáticamente en DML**
- ✅ Envío pasa a estado **"RECIBIDO"**
- ✅ Ficha con faltante se actualiza (si aplica)
- ✅ Estadísticas de movimiento se registran

---

## <a name="estadisticas"></a> 6. ESTADÍSTICAS Y REPORTES

**Acceso:** Menú Estadísticas (solo DML_REPUESTOS y ADMIN)  
**URL:** `http://localhost:5000/estadisticas`

### 6.1 TARJETAS DE RESUMEN

Al entrar a Estadísticas, se muestran tarjetas con:
- **Total de Repuestos:** Cantidad de SKUs únicos en la base
- **En [Ubicación]:** Repuestos disponibles en la ubicación actual
- **Movimientos Totales:** (DML) Cantidad de usos registrados
- **Fichas Completadas:** (DML) Equipos que terminaron reparación
- **Stock Crítico:** Repuestos con stock ≤2

### 6.2 REPUESTOS CON STOCK BAJO

Tabla de repuestos con alertas:
- Código y descripción
- Stock actual con emoji de alerta
- Nivel (AGOTADO, ÚLTIMO, CRÍTICO)

**Para reposición:**
- Click en el repuesto para ver más detalles
- Contactar a RAYPAC para envío (si es DML)

### 6.3 TOP 10 REPUESTOS MÁS UTILIZADOS (solo DML)

Tabla con:
- Ranking (1-10)
- Código del repuesto
- Total de veces utilizado
- Cantidad total utilizada
- Stock actual
- Fecha de último uso

**Utilidad:** Saber qué repuestos necesitas mantener siempre en stock

### 6.4 SELECTOR DE UBICACIÓN (ADMIN)

En la página de Estadísticas, botones para cambiar entre:
- **RAYPAC:** Muestra solo stock crítico de RAYPAC
- **DML:** Muestra estadísticas completas + Top 10

---

## <a name="prueba"></a> 7. DATOS DE PRUEBA

### 7.1 CARGAR DATOS INICIALES

**Comando:**
```bash
python seed_data_minimal.py
```

**Qué carga:**
- ✅ 4 usuarios (admin, raypac, tecnico, repuestos)
- ✅ 10 repuestos de ejemplo (códigos A000001-A000010)
- ✅ Stock inicial RAYPAC: 10 repuestos con cantidades 0-15
- ✅ Stock inicial DML: 10 repuestos con cantidades 0-5
- ✅ 2 ingresos RAYPAC (1 freezado, 1 editable)
- ✅ 1 ficha DML (#501) con ticket automático
- ✅ 1 envío recibido (RP-2024-00100)
- ✅ Estadísticas de uso iniciales

**Después de ejecutar:**
- Base de datos limpia y lista para pruebas
- Todos los usuarios activos
- Datos realistas para testing de flujos completos

### 7.2 ESCENARIOS DE PRUEBA RECOMENDADOS

**Escenario 1: Ingreso a Reparación**
1. Login como RAYPAC
2. Crear nuevo ingreso (datos de prueba)
3. Agregar remito y freezar
4. Login como DML_ST
5. Ver ficha creada automáticamente
6. Cambiar estado a "EN REPARACIÓN"

**Escenario 2: Uso de Repuestos**
1. Login como DML_ST
2. En la ficha #501: agregar repuesto A000001 (qty 2)
3. Verificar stock DML se descuenta
4. Verificar alerta en Estadísticas

**Escenario 3: Envío RAYPAC → DML**
1. Login como RAYPAC
2. Crear nuevo envío con A000005 (qty 3)
3. Login como DML_REPUESTOS
4. Confirmar recepción
5. Verificar stock DML subió

**Escenario 4: Stock Crítico**
1. Login como DML_REPUESTOS
2. Ver Estadísticas
3. Verificar repuestos con stock ≤2 listados
4. Observar colores de alertas (🔴🟡🟠)

**Escenario 5: Cierre de Ficha**
1. En la ficha, cambiar a "MÁQUINA LISTA PARA RETIRAR"
2. Ingresar diagnóstico final
3. Cambiar a "MÁQUINA ENTREGADA"
4. Descargar PDF

---

## <a name="troubleshooting"></a> 8. SOLUCIÓN DE PROBLEMAS

### P: No puedo iniciar sesión
**R:** 
1. Verifica que el servidor esté corriendo (`python CODIGO_FUENTE/app.py`)
2. Comprueba usuario y contraseña correctos (ver tabla en Sección 1)
3. Si la BD está corrupta, ejecuta: `python seed_data_minimal.py`

### P: El servidor dice "Port 5000 already in use"
**R:** 
```bash
# Windows - Detener todos los procesos Python
taskkill /F /IM python.exe
# Esperar 2 segundos
Start-Sleep -Seconds 2
# Reiniciar servidor
python CODIGO_FUENTE/app.py
```

### P: Stock no se descuenta al usar repuestos
**R:**
1. Verifica que el repuesto exista en stock DML
2. Asegúrate que la ficha es de DML (no RAYPAC)
3. Revisa cantidad disponible antes de agregar
4. Guarda los cambios de la ficha

### P: No veo mi envío después de confirmar
**R:**
1. Recarga la página (F5)
2. Verifica que estés en la ubicación correcta
3. Si el envío desapareció, check estado "RECIBIDO" en historial

### P: Alerta de stock no se actualiza
**R:**
1. Las alertas se calculan en tiempo real
2. Recarga la página para ver cambios
3. Si persiste, verifica stock actual del repuesto en la tabla
4. Contacta a admin si hay inconsistencia

### P: El ticket no se generó automáticamente
**R:**
1. Verifica que la ficha se guardó correctamente
2. Busca el número de ficha en la página de Fichas
3. Si no existe, intenta crear nueva ficha
4. Si sigue fallando: reinicia servidor y vuelve a intentar

### P: No puedo editar un ingreso RAYPAC
**R:**
- Es normal si está **FREEZADO** (status protegido)
- Solo ADMIN puede descongelar (requiere contraseña)
- Para pruebas: contacta a admin@dml.local

### P: La búsqueda de repuestos no funciona
**R:**
1. Verifica haber escrito bien código/descripción
2. Usa el botón "Limpiar" para resetear filtros
3. Intenta buscar solo por código (ej. A000001)
4. Recarga la página

### P: No veo todos los repuestos
**R:**
1. Verifica tu rol (RAYPAC solo ve RAYPAC, DML solo ve DML)
2. Si eres ADMIN, usa botones RAYPAC/DML para cambiar ubicación
3. Comprueba que los repuestos fueron agregados correctamente

---

## 📞 CONTACTO Y SOPORTE

**Para problemas técnicos:**
- Contactar a: desarrollo@dml.local

**Para reportar bugs:**
- Email con detalles de qué hiciste y qué pasó
- Incluir captura de pantalla si es posible
- Indicar navegador y URL donde ocurrió

**Para sugerencias de mejora:**
- Crear issue en el repositorio GitHub
- O email con descripción de mejora sugerida

---

**Última actualización:** 9 de Diciembre de 2025  
**Sistema:** Versión 1.0 - Production Ready
