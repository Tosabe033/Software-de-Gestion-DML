# Manual de Usuario - Sistema DML ST & Repuestos

## 1. Acceso
- URL local: `http://localhost:5000`
- Usuarios demo:
  - Admin: `admin@dml.local` / `admin`
  - RAYPAC: `raypac@dml.local` / `raypac`
  - Técnico DML: `tecnico@dml.local` / `tecnico`
  - Repuestos DML: `repuestos@dml.local` / `repuestos`

## 2. Roles y qué puede ver
- **RAYPAC**: Ingresar equipos en RAYPAC, gestionar stock RAYPAC, enviar repuestos a DML.
- **DML_ST**: Gestionar fichas/tickets en DML, registrar avances y repuestos utilizados.
- **DML_REPUESTOS**: Gestionar stock DML, recepcionar envíos desde RAYPAC, marcar faltantes resueltos.
- **ADMIN**: Acceso total + gestión de usuarios.

## 3. Flujo resumido
1) **Ingreso de equipo en RAYPAC**
   - Menú RAYPAC → "Nuevo ingreso".
   - Completar datos obligatorios (cliente, serie, modelo, comercial, contacto).
   - Guardar (quedará editable).

2) **Remito y envío de la máquina a DML**
   - En el mismo ingreso RAYPAC: ingresar N° de remito cuando se despacha.
   - Confirmar envío → el ingreso queda freezado (solo se puede desfreezar con contraseña de administrador).

3) **Ingreso en DML (ficha y ticket)**
   - Menú Fichas ST → "Nueva".
   - Completar campos obligatorios, asignar técnico.
   - Al confirmar se genera **ticket** automático (número correlativo) y se envía email/impresión.

4) **Trabajo del técnico (DML_ST)**
   - Actualizar estados: A LA ESPERA DE REVISIÓN → EN REPARACIÓN → A LA ESPERA DE REPUESTOS → MÁQUINA LISTA PARA RETIRAR → MÁQUINA ENTREGADA.
   - Registrar repuestos usados (hasta 15). El stock DML se descuenta al guardar.
   - Si falta repuesto, marcarlo para que repuestos lo gestione.

5) **Gestión de repuestos (DML_REPUESTOS)**
   - Menú Stock (ubicación DML): ver alertas, editar cantidades, cargar nuevos repuestos.
   - Menú Envíos: confirmar recepciones desde RAYPAC (carga automática en stock DML).
   - Cuando llega un faltante, actualizar la ficha a EN STOCK para liberar al técnico.

6) **Stock RAYPAC y envíos a DML (RAYPAC)**
   - Menú Stock (ubicación RAYPAC): cargar/editar repuestos propios.
   - Menú Envíos → "Nuevo": seleccionar códigos y cantidades a enviar, confirmar (se descuenta de RAYPAC).

7) **Cierre de ficha y entrega**
   - Cuando el equipo está listo: cambiar a MÁQUINA LISTA PARA RETIRAR y luego MÁQUINA ENTREGADA.
   - Generar ficha PDF e imprimir/descargar desde la ficha.

## 4. Qué ver en el dashboard por rol
- **RAYPAC**: equipos sin remito, envíos pendientes, stock RAYPAC en alerta.
- **DML_REPUESTOS**: stock DML en alerta, envíos pendientes, fichas esperando repuestos.
- **DML_ST**: fichas en reparación, fichas esperando repuestos, tickets activos.
- **ADMIN**: visión consolidada de equipos, fichas abiertas, envíos y stock en alerta.

## 5. Gestión de Stock (según documento técnico)

### 5.1 Stock por Ubicación
El sistema gestiona stock en **2 ubicaciones independientes**:
- **RAYPAC** (Casa Matriz): stock de repuestos importados
- **DML** (Servicio Técnico): stock local para reparaciones

### 5.2 Permisos por Rol

| Acción | RAYPAC | DML_REPUESTOS | ADMIN |
|--------|---------|---------------|-------|
| Ver stock RAYPAC | ✅ | ❌ | ✅ |
| Ver stock DML | ❌ | ✅ | ✅ |
| Agregar repuestos | ✅ (RAYPAC) | ✅ (DML) | ✅ (ambos) + contraseña |
| Editar stock | ✅ (RAYPAC) | ✅ (DML) | ✅ (ambos) + contraseña |
| Eliminar repuestos | ❌ | ❌ | ✅ + contraseña |
| Búsqueda/filtrado | ✅ | ✅ | ✅ |
| Ver estadísticas | ❌ | ✅ | ✅ |

### 5.3 Funcionalidades Implementadas

#### ✅ Ingresar nuevos repuestos
- Cada usuario puede agregar repuestos a su ubicación
- ADMIN necesita contraseña (ADMIN2024) para altas/bajas
- RAYPAC y DML_REPUESTOS pueden agregar libremente en su ubicación
- Campos: código (SKU), descripción, cantidad inicial

#### ✅ Búsqueda de repuestos
- Búsqueda por código o descripción
- Filtrado en tiempo real por ubicación
- Botón "Limpiar" para resetear filtros

#### ✅ Alertas de stock automáticas
- **🔴 ROJO** (0 unidades): Repuesto faltante
- **🟡 AMARILLO** (1 unidad): Último repuesto disponible
- **🟠 NARANJA** (2 unidades): Pocos repuestos disponibles
- **🟢 VERDE** (>2 unidades): Stock OK

Las alertas se calculan **por ubicación** y se actualizan automáticamente al:
- Usar repuestos en fichas de reparación
- Recepcionar envíos de RAYPAC a DML
- Editar cantidades manualmente

#### ✅ Estadísticas de uso de repuestos
- Top 10 repuestos más utilizados
- Repuestos críticos (stock ≤2)
- Total de movimientos por código
- Fecha de último uso
- Stock actual vs. usos registrados

**Acceso**: 
- Dashboard DML_REPUESTOS → "Estadísticas de repuestos"
- Página de stock → botón "📊 Estadísticas de uso"

#### ✅ Envío de repuestos RAYPAC → DML
1. Usuario RAYPAC: Menú "Envíos" → "Nuevo"
2. Seleccionar repuestos y cantidades
3. Ingresar N° de remito
4. Confirmar → se **descuenta de stock RAYPAC**
5. Usuario DML_REPUESTOS: Menú "Envíos" → Confirmar recepción
6. Stock se **suma automáticamente a DML**
7. Email automático a RAYPAC confirmando recepción

#### ✅ Descuento automático al usar repuestos
- Al agregar repuesto a una ficha DML, el sistema verifica stock DML
- Si hay stock: descuenta automáticamente y marca "EN STOCK"
- Si no hay: marca "EN FALTA" y genera alerta
- Se actualiza estadística de uso del repuesto

### 5.4 Flujo de Reposición de Stock

```
RAYPAC (Stock Inicial)
    ↓ [Envío con remito]
DML recibe y confirma
    ↓ [Stock sube en DML, baja en RAYPAC]
DML usa en reparaciones
    ↓ [Stock baja en DML]
Alerta automática (≤2)
    ↓ [Email a repuestos@dml.local]
RAYPAC envía reposición
```

### 5.5 Selector de Ubicación (solo ADMIN)
- ADMIN ve botones **RAYPAC** / **DML** en la página de stock
- Permite cambiar entre ubicaciones sin salir de la pantalla
- Cada ubicación muestra sus propios repuestos y alertas

## 6. Reglas rápidas
- Cada rol solo ve su ubicación de stock (RAYPAC o DML).
- Los equipos se registran en RAYPAC; los repuestos se gestionan por ubicación.
- Los envíos son solo de repuestos RAYPAC → DML.
- Tickets se generan al crear la ficha en DML y acompañan todo el seguimiento.

## 7. Soporte
- Para resetear datos de prueba: ejecutar `python seed_data.py` en el entorno activado.
- Usuario admin puede crear/activar/desactivar usuarios en "Admin → Usuarios".
