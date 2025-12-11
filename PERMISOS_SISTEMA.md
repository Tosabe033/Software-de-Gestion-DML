# SISTEMA DE PERMISOS - DML SOFTWARE DE GESTIÓN

## Resumen del Cambio

El sistema ahora implementa **permisos granulares de lectura/escritura** por rol, según lo especificado por David en el documento del proyecto.

---

## Matriz de Permisos por Rol

### 🔹 ADMIN (Super Usuario)
- ✅ **LECTURA + ESCRITURA** en TODAS las secciones
- ✅ Puede cambiar entre ubicaciones de stock (RAYPAC/DML)
- ✅ Acceso completo sin restricciones

### 🔹 RAYPAC (Casa Matriz)
- ✅ **ESCRITURA**: Ingresos RAYPAC (crear, editar, freezar, enviar a ST)
- ✅ **ESCRITURA**: Stock RAYPAC (agregar repuestos, enviar a DML)
- 👁️ **SOLO LECTURA**: Fichas DML (consultar estados de reparación)
- 👁️ **SOLO LECTURA**: Stock DML (ver disponibilidad de repuestos)
- ❌ **SIN ACCESO**: Edición de fichas DML, tickets

### 🔹 DML_ST (Técnico de Servicio)
- ✅ **ESCRITURA**: Fichas DML (crear, editar, cerrar)
- ✅ **ESCRITURA**: Tickets (crear, gestionar)
- 👁️ **SOLO LECTURA**: Ingresos RAYPAC (ver para crear fichas)
- 👁️ **SOLO LECTURA**: Stock DML (consultar disponibilidad)
- ❌ **SIN ACCESO**: Edición de ingresos RAYPAC, gestión de stock

### 🔹 DML_REPUESTOS (Encargado de Stock)
- ✅ **ESCRITURA**: Stock DML (agregar, editar, gestionar)
- ✅ **ESCRITURA**: Envíos de repuestos (recibir de RAYPAC)
- 👁️ **SOLO LECTURA**: Fichas DML (ver qué repuestos se necesitan)
- ❌ **SIN ACCESO**: Edición de ingresos RAYPAC, edición de fichas DML

---

## Flujo de Trabajo Correcto

### 1. **Ingreso de Máquina**
1. **RAYPAC** crea ingreso en "Ingresos RAYPAC"
2. **RAYPAC** completa datos y FREEZA (envía a ST)
3. **DML_ST** VE el ingreso en modo SOLO LECTURA
4. **DML_ST** crea la "Ficha DML" desde el botón en RAYPAC

### 2. **Reparación en DML**
1. **DML_ST** edita la ficha, agrega repuestos, cambia estados
2. **DML_ST** consulta stock DML (solo lectura) para ver disponibilidad
3. **RAYPAC** puede consultar estado de la ficha (solo lectura)
4. **DML_ST** cierra la ficha cuando termina

### 3. **Gestión de Stock**
1. **DML_REPUESTOS** gestiona stock DML (agregar, editar)
2. **RAYPAC** gestiona stock RAYPAC, envía repuestos a DML
3. **DML_ST** consulta stock DML (solo lectura) durante reparaciones
4. **RAYPAC** consulta stock DML (solo lectura) para verificar disponibilidad

---

## Indicadores Visuales

### Badge "Modo Solo Lectura"
- Aparece en la esquina superior derecha de las vistas
- Color: 🔵 Azul (badge-info)
- Se muestra cuando el usuario tiene solo permisos de lectura

### Botones Ocultos
- **RAYPAC en Fichas DML**: No ve botones "Editar Ficha" ni "Cerrar Ficha"
- **DML_ST en RAYPAC**: No ve botones "Editar" ni "Freezar y Enviar a ST"
- **DML_ST en Stock**: No ve botón "+ Nuevo Repuesto"

---

## Cambios Técnicos Implementados

### 1. Nuevo Decorator `@permission_required`
```python
@permission_required(read_roles=["RAYPAC"], write_roles=["DML_ST"])
```
- Permite definir roles con SOLO LECTURA vs ESCRITURA
- ADMIN siempre tiene acceso completo
- Pasa flag `readonly=True` a la vista si es solo lectura

### 2. Rutas Actualizadas

#### Ingresos RAYPAC
- `/raypac` - DML_ST: lectura | RAYPAC: escritura
- `/raypac/<id>` - DML_ST: lectura | RAYPAC: escritura
- `/raypac/new` - Solo RAYPAC (escritura)
- `/raypac/<id>/edit` - Solo RAYPAC (escritura)

#### Fichas DML
- `/dml` - RAYPAC: lectura | DML_REPUESTOS: lectura | DML_ST: escritura
- `/dml/<id>` - RAYPAC: lectura | DML_REPUESTOS: lectura | DML_ST: escritura
- `/dml/new/<raypac_id>` - Solo DML_ST (escritura)
- `/dml/<id>/edit` - Solo DML_ST (escritura)

#### Stock
- `/stock` - DML_ST: lectura | DML_REPUESTOS: escritura | RAYPAC: escritura (solo su ubicación)
- `/stock/new` - Solo DML_REPUESTOS y RAYPAC (escritura)
- `/stock/edit/<codigo>` - Solo DML_REPUESTOS y RAYPAC (escritura)

### 3. Templates Actualizados
- `raypac_list.html` - Oculta "Nuevo Ingreso" si readonly
- `raypac_view.html` - Oculta "Editar" y "Freezar" si readonly
- `dml_list.html` - Muestra badge "Solo Lectura" si readonly
- `dml_view.html` - Oculta "Editar" y "Cerrar Ficha" si readonly, solo muestra "Ver Ticket" y "Descargar PDF"
- `stock_list.html` - Oculta "+ Nuevo Repuesto" si readonly

---

## Solución al Problema Original

### ❌ Problema
- Técnico (DML_ST) no veía ingresos RAYPAC → No podía crear fichas
- Sistema bloqueaba pestañas completas por rol
- Flujo de trabajo interrumpido

### ✅ Solución
- Técnico (DML_ST) VE ingresos RAYPAC en modo lectura
- Puede acceder a detalles del ingreso para crear fichas
- RAYPAC puede consultar estados de reparación sin editar
- Cada rol tiene visibilidad necesaria para su trabajo

---

## Testing Multi-Usuario

### Escenario de Prueba
1. **Chrome Normal** → Login como RAYPAC
2. **Chrome Incógnito** → Login como DML_ST (Técnico)

### Flujo Completo
1. RAYPAC crea ingreso → RAYPAC lo FREEZA
2. DML_ST ve el ingreso en "Ingresos RAYPAC" (lectura)
3. DML_ST crea ficha DML desde el botón
4. DML_ST edita ficha, agrega repuestos
5. RAYPAC consulta estado de la ficha (lectura)
6. DML_ST cierra ficha

---

## Notas Importantes

1. **Cookies de Sesión**: Usar diferentes navegadores o modo incógnito para multi-usuario
2. **ADMIN siempre bypassed**: No se le aplican restricciones de readonly
3. **Compatibilidad**: El decorator antiguo `@role_required` sigue funcionando para rutas que no necesitan granularidad
4. **Badge Visual**: Ayuda al usuario a entender que está en modo solo lectura

---

## Próximos Pasos

- [ ] Desplegar a Render.com (git commit + push)
- [ ] Probar en producción con múltiples usuarios reales
- [ ] Confirmar con David que el flujo es correcto
- [ ] Implementar cambios adicionales de lógica que David solicitó en la demo

---

**Fecha de Implementación**: 11 de Diciembre de 2025  
**Desarrolladores**: Tomas Palumbo, Salvador Merayo  
**Docente**: Hugo Rodriguez
