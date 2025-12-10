# 🏗️ ARQUITECTURA TÉCNICA
## Sistema de Gestión de Servicio Técnico - DML Electricidad Industrial

---

## 📐 ESTRUCTURA GENERAL

```
┌─────────────────────────────────────────────────┐
│           FRONTEND (Browser)                    │
│  ┌───────────────────────────────────────────┐  │
│  │ Bootstrap 5.3.3 + Jinja2 Templates       │  │
│  │ JavaScript Validación en Tiempo Real     │  │
│  └───────────────────────────────────────────┘  │
└────────────────┬────────────────────────────────┘
                 │ HTTP/REST
┌────────────────▼────────────────────────────────┐
│         BACKEND (Flask 2.x)                     │
│  ┌───────────────────────────────────────────┐  │
│  │ 25+ Rutas (GET, POST, PUT, DELETE)       │  │
│  │ Autenticación (Login + Roles)             │  │
│  │ Generación PDF (ReportLab)                │  │
│  │ Email SMTP (HTML Templates)               │  │
│  │ Validaciones Servidor                     │  │
│  └───────────────────────────────────────────┘  │
└────────────────┬────────────────────────────────┘
                 │ SQL
┌────────────────▼────────────────────────────────┐
│       DATABASE (SQLite3)                        │
│  ┌───────────────────────────────────────────┐  │
│  │ 19 Tablas Normalizadas                    │  │
│  │ Integridad Referencial Completa           │  │
│  │ Índices para Performance                  │  │
│  └───────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

---

## 🗄️ ESQUEMA BASE DE DATOS

### Tablas Principales:

#### 1. **raypac_entries** (Ingreso de máquinas)
```sql
CREATE TABLE raypac_entries (
    id INTEGER PRIMARY KEY,
    numero_correlativo INTEGER UNIQUE,
    cliente TEXT NOT NULL,
    numero_serie TEXT NOT NULL,
    modelo TEXT NOT NULL,
    tipo_maquina TEXT,
    comercial TEXT,
    mail TEXT,
    numero_remito TEXT,
    is_frozen BOOLEAN DEFAULT 0,
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

**Lógica:**
- `numero_correlativo`: Auto-incremental desde 1
- `is_frozen`: 0 (editable) / 1 (bloqueado)
- `numero_remito`: Código para desfreezar

#### 2. **dml_fichas** (Fichas de reparación)
```sql
CREATE TABLE dml_fichas (
    id INTEGER PRIMARY KEY,
    numero_ficha INTEGER UNIQUE,  -- Desde 500+
    raypac_id INTEGER NOT NULL,
    cliente TEXT NOT NULL,
    numero_serie TEXT,
    modelo TEXT,
    tipo_maquina TEXT,
    comercial TEXT,
    mail TEXT,
    descripcion_problema TEXT,
    diagnostico_inicial TEXT,
    diagnostico_reparacion TEXT,
    estado_reparacion TEXT DEFAULT 'A LA ESPERA DE REVISION',
    is_closed BOOLEAN DEFAULT 0,  -- 1 = FINALIZADO
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_egreso TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (raypac_id) REFERENCES raypac_entries(id)
)
```

**Estados válidos:**
- A LA ESPERA DE REVISIÓN
- EN REPARACIÓN
- A LA ESPERA DE REPUESTOS
- MÁQUINA LISTA
- FINALIZADO (cuando is_closed=1)

#### 3. **dml_repuestos** (Repuestos en fichas)
```sql
CREATE TABLE dml_repuestos (
    id INTEGER PRIMARY KEY,
    ficha_id INTEGER NOT NULL,
    codigo TEXT NOT NULL,
    cantidad INTEGER,
    en_stock BOOLEAN DEFAULT 1,
    en_falta BOOLEAN DEFAULT 0,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ficha_id) REFERENCES dml_fichas(id)
)
```

**Lógica:**
- Max 15 repuestos por ficha (validado en app.py)
- `en_stock`: 1 (hay) / 0 (no hay)
- `en_falta`: 1 (se marcó falta) / 0 (normal)

#### 4. **tickets** (Tickets de seguimiento)
```sql
CREATE TABLE tickets (
    id INTEGER PRIMARY KEY,
    numero_ticket TEXT UNIQUE,  -- TK-YYYY-SERIE-00001
    ficha_id INTEGER NOT NULL,
    estado_ticket TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ficha_id) REFERENCES dml_fichas(id)
)
```

#### 5. **stock_dml** (Inventario de repuestos)
```sql
CREATE TABLE stock_dml (
    id INTEGER PRIMARY KEY,
    codigo TEXT UNIQUE,
    nombre TEXT NOT NULL,
    cantidad_actual INTEGER DEFAULT 0,
    cantidad_minima INTEGER DEFAULT 2,
    descripcion TEXT,
    ubicacion TEXT,  -- RAYPAC / DML
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

#### 6. **stock_ubicaciones** (Ubicaciones específicas)
```sql
CREATE TABLE stock_ubicaciones (
    id INTEGER PRIMARY KEY,
    codigo_repuesto TEXT,
    ubicacion TEXT,  -- RAYPAC / DML
    cantidad INTEGER DEFAULT 0,
    FOREIGN KEY (codigo_repuesto) REFERENCES stock_dml(codigo)
)
```

#### 7. **estadisticas_repuestos** (Tracking de uso)
```sql
CREATE TABLE estadisticas_repuestos (
    id INTEGER PRIMARY KEY,
    codigo_repuesto TEXT,
    total_usos INTEGER DEFAULT 0,
    cantidad_utilizada INTEGER DEFAULT 0,
    ultimo_uso TIMESTAMP,
    FOREIGN KEY (codigo_repuesto) REFERENCES stock_dml(codigo)
)
```

#### 8. **audit_log** (Trazabilidad)
```sql
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    action TEXT NOT NULL,  -- CREATE, EDIT, DELETE, CLOSE, FREEZE, etc.
    table_name TEXT NOT NULL,
    record_id INTEGER,
    old_value TEXT,
    new_value TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

#### 9. **usuarios** (Autenticación)
```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,  -- werkzeug.security.generate_password_hash
    rol TEXT DEFAULT 'DML_ST',  -- ADMIN, RAYPAC, DML_ST, DML_REPUESTOS
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

**Roles disponibles:**
- `ADMIN`: Acceso completo
- `RAYPAC`: Gestión RAYPAC + tickets
- `DML_ST`: Reparación fichas
- `DML_REPUESTOS`: Gestión stock

#### 10. **envios_repuestos** (Envíos RAYPAC→DML)
```sql
CREATE TABLE envios_repuestos (
    id INTEGER PRIMARY KEY,
    numero_remito TEXT UNIQUE,
    codigo_repuesto TEXT,
    cantidad INTEGER,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_recepcion TIMESTAMP,
    estado TEXT DEFAULT 'EN TRANSITO'  -- EN TRANSITO / RECIBIDO
)
```

### Tablas Adicionales (9 más):
- `fichas_partes`: Componentes por ficha (12 estándar)
- `partes_equipos`: Catálogo de partes
- `usuarios_cambios`: Historial de cambios de contraseña
- `sesiones`: Control de sesiones activas
- `configuracion`: Parámetros del sistema
- `plantillas_email`: Templates HTML para mails
- `backup_dml_fichas`: Backup de fichas cerradas
- `estadisticas_diarias`: Resumen diario de operaciones
- `notificaciones`: Cola de notificaciones

---

## 🔄 FLUJOS DE PROCESO

### FLUJO 1: RAYPAC INGRESO → ENVÍO → DML

```
1. RAYPAC INGRESA
   │
   ├─ POST /raypac/new
   │  └─ INSERT raypac_entries
   │     ├─ numero_correlativo = AUTO++
   │     ├─ is_frozen = 0
   │     └─ LOG AUDIT
   │
2. AGREGAR REMITO (FREEZING)
   │
   ├─ POST /raypac/<id>/freeze
   │  └─ UPDATE raypac_entries SET is_frozen=1, numero_remito=?
   │     └─ LOG AUDIT
   │
3. ENVIAR A DML
   │
   ├─ POST /raypac/<id>/send
   │  └─ INSERT tickets (auto-creado)
   │     ├─ numero_ticket = TK-YYYY-SERIE-00001
   │     ├─ SEND EMAIL a comercial
   │     └─ LOG AUDIT
   │
4. DESFREEZAR (si hay error)
   │
   ├─ POST /raypac/<id>/unfreeze
   │  └─ VERIFY numero_remito (código dinámico)
   │     ├─ UPDATE raypac_entries SET is_frozen=0
   │     ├─ ALLOW edición nuevamente
   │     └─ LOG AUDIT
   │
5. DML RECIBE EN FICHA
   │
   └─ POST /dml/new/<raypac_id>
      └─ INSERT dml_fichas
         ├─ numero_ficha = 500+
         ├─ Copia datos de raypac
         └─ LOG AUDIT
```

### FLUJO 2: DML REPARACIÓN → REPUESTOS → CIERRE

```
1. DML RECIBE FICHA
   │
   ├─ GET /dml/<id>
   │  └─ Mostrar detalle ficha
   │
2. AGREGAR REPUESTOS
   │
   ├─ POST /dml/<id>/repuestos/agregar
   │  ├─ VALIDATE: max 15 repuestos
   │  ├─ VALIDATE: codigo existe
   │  ├─ INSERT dml_repuestos
   │  ├─ UPDATE stock_dml (descuenta)
   │  ├─ UPDATE estadisticas_repuestos (incrementa uso)
   │  └─ LOG AUDIT
   │
3. EDITAR ESTADO REPARACIÓN
   │
   ├─ POST /dml/<id>/edit
   │  ├─ UPDATE dml_fichas SET estado_reparacion=?
   │  ├─ TICKET.estado = NEW estado
   │  └─ LOG AUDIT
   │
4. MARCAR REPUESTO EN FALTA
   │
   ├─ POST /dml/<id>/marcar-falta/<repuesto_id>
   │  ├─ UPDATE dml_repuestos SET en_falta=1
   │  └─ LOG AUDIT
   │
5. REPUESTO LLEGA
   │
   ├─ POST /dml/<id>/marcar-llegada/<repuesto_id>
   │  ├─ UPDATE dml_repuestos SET en_falta=0, en_stock=1
   │  ├─ UPDATE stock_dml (descuenta si llegó)
   │  └─ LOG AUDIT
   │
6. GENERAR PDF (EN CUALQUIER MOMENTO)
   │
   ├─ GET /dml/<id>/pdf
   │  ├─ SELECT * FROM dml_fichas
   │  ├─ SELECT * FROM dml_repuestos
   │  ├─ SELECT * FROM fichas_partes
   │  ├─ GENERATE PDF (ReportLab)
   │  │  ├─ Columna 1: Información general
   │  │  └─ Columna 2: Estado equipos/partes
   │  └─ RETURN PDF BLOB
   │
7. CERRAR FICHA (NUEVO)
   │
   ├─ POST /dml/<id>/close
   │  ├─ UPDATE dml_fichas SET is_closed=1, estado_reparacion='FINALIZADO'
   │  ├─ UPDATE dml_fichas SET fecha_egreso=NOW()
   │  ├─ SEND EMAIL "MÁQUINA LISTA PARA RETIRAR"
   │  │  └─ HTML Template con detalles
   │  ├─ LOG AUDIT
   │  └─ SHOW badge "✅ FICHA FINALIZADA"
   │
8. TICKET LISTO PARA RETIRAR
   │
   └─ GET /ticket/<numero_ticket>/print
      ├─ SELECT * FROM tickets WHERE numero_ticket=?
      ├─ GENERATE print-friendly format (2 copias)
      └─ SHOW barcode simulado
```

### FLUJO 3: GESTIÓN DE STOCK

```
1. VER STOCK GENERAL
   │
   ├─ GET /stock
   │  └─ SELECT * FROM stock_dml ORDER BY cantidad_actual
   │     ├─ COLOREAR por alerta:
   │     │  ├─ 🔴 ROJO: cantidad=0
   │     │  ├─ 🟡 AMARILLO: cantidad=1
   │     │  └─ 🟠 NARANJA: cantidad=2
   │     └─ SHOW ubicaciones (RAYPAC / DML)
   │
2. AGREGAR NUEVO REPUESTO
   │
   ├─ POST /stock/new (ADMIN2024 password)
   │  ├─ INSERT stock_dml
   │  ├─ AUTO generar codigo
   │  ├─ SET ubicacion = RAYPAC (por default)
   │  └─ LOG AUDIT
   │
3. ENVÍO RAYPAC → DML
   │
   ├─ POST /envios/new
   │  ├─ INSERT envios_repuestos
   │  ├─ UPDATE stock_ubicaciones RAYPAC (descuenta)
   │  └─ UPDATE stock_ubicaciones DML (suma)
   │
4. ESTADÍSTICAS (Auto-calculadas)
   │
   ├─ GET /estadisticas
   │  ├─ SELECT TOP 10 FROM estadisticas_repuestos ORDER BY total_usos DESC
   │  ├─ SELECT * FROM stock_dml WHERE cantidad_actual <= 2 (CRÍTICOS)
   │  ├─ CALC: Total repuestos, En inventario, Movimientos, Fichas completadas
   │  └─ SHOW dashboard con gráficos
   │
5. ALERTAS AUTOMÁTICAS
   │
   └─ Background Job (cada 1 hora)
      ├─ SELECT * FROM stock_dml WHERE cantidad_actual <= 1
      └─ SEND EMAIL alerta a DML_REPUESTOS
```

---

## 🔐 SEGURIDAD

### Autenticación
```python
# Login
usuario = find_user(username)
if check_password_hash(usuario.password_hash, password):
    session['user_id'] = usuario.id
    session['rol'] = usuario.rol
    return redirect('/dashboard')

# Logout
session.clear()
```

### Autorización por Rol
```python
# Decorator
@require_role('ADMIN', 'DML_ST')
def edit_ficha(id):
    # Solo ADMIN o DML_ST pueden editar fichas
    pass

# En templates
{% if current_user.rol in ['ADMIN', 'DML_REPUESTOS'] %}
    <a href="/stock/new">Agregar Repuesto</a>
{% endif %}
```

### Protección de Endpoints
```python
# Password protection para acciones críticas
@app.route('/stock/new', methods=['POST'])
def create_stock():
    admin_password = request.form.get('password')
    if admin_password != 'ADMIN2024':
        abort(403)  # Forbidden
    # ... crear repuesto
```

### SQL Injection Prevention
```python
# GOOD - Parameterized queries
db.execute("SELECT * FROM dml_fichas WHERE id = ?", (id,))

# BAD - String concatenation (NUNCA)
# db.execute(f"SELECT * FROM dml_fichas WHERE id = {id}")
```

---

## 📱 API REST (Rutas principales)

### RAYPAC
```
GET  /raypac                           Lista ingreso RAYPAC
GET  /raypac/<id>                      Detalle ingreso RAYPAC
POST /raypac/new                       Crear nuevo ingreso
POST /raypac/<id>/edit                 Editar ingreso RAYPAC
POST /raypac/<id>/freeze               Freezear con remito
POST /raypac/<id>/unfreeze             Desfreezear con código
```

### DML FICHAS
```
GET  /dml                              Lista fichas DML
GET  /dml/<id>                         Detalle ficha
POST /dml/new/<raypac_id>              Crear ficha desde RAYPAC
POST /dml/<id>/edit                    Editar ficha
POST /dml/<id>/close                   Cerrar/finalizar ficha (NUEVO)
GET  /dml/<id>/pdf                     Descargar PDF ficha
```

### REPUESTOS EN FICHAS
```
POST /dml/<id>/repuestos/agregar       Agregar repuesto a ficha
POST /dml/<id>/marcar-falta/<rep_id>   Marcar como falta
POST /dml/<id>/marcar-llegada/<rep_id> Marcar como llegado
POST /dml/<id>/repuestos/eliminar/<id> Eliminar repuesto
```

### TICKETS
```
GET  /tickets                          Lista todos tickets
GET  /ticket/<numero>                  Detalle ticket (público)
GET  /ticket/<numero>/print            Solapa imprimible
POST /dml/<id>/crear-ticket            Crear ticket manualmente
```

### STOCK
```
GET  /stock                            Ver inventario completo
GET  /stock/<codigo>                   Detalle stock
POST /stock/new                        Agregar repuesto (ADMIN2024)
POST /stock/<codigo>/edit              Editar stock
```

### ESTADÍSTICAS
```
GET  /estadisticas                     Dashboard estadísticas
GET  /api/stock-alerts                 Alertas JSON (AJAX)
```

### ADMIN
```
GET  /usuarios                         Gestión usuarios
GET  /audit-log                        Ver cambios
POST /backup                           Descargar backup BD
```

---

## 🔧 STACK TECNOLÓGICO

### Backend
```
Flask 2.3+              Web framework
SQLite3 3.x             Database
Python 3.8+             Runtime
ReportLab 4.0+          PDF generation
python-dotenv           Config management
Werkzeug 2.x            Security (password hash)
```

### Frontend
```
Bootstrap 5.3.3         CSS framework
Jinja2                  Template engine
JavaScript (vanilla)    Client validation
HTML5                   Markup
```

### Email
```
SMTP (configurable)     Mail server
Python smtplib          SMTP client
HTML templates          Email design
```

---

## 📊 PERFORMANCE

### Índices de BD
```sql
CREATE INDEX idx_raypac_numero ON raypac_entries(numero_correlativo);
CREATE INDEX idx_ficha_numero ON dml_fichas(numero_ficha);
CREATE INDEX idx_ficha_raypac ON dml_fichas(raypac_id);
CREATE INDEX idx_ticket_ficha ON tickets(ficha_id);
CREATE INDEX idx_repuesto_codigo ON dml_repuestos(codigo);
CREATE INDEX idx_stock_codigo ON stock_dml(codigo);
CREATE INDEX idx_audit_timestamp ON audit_log(timestamp);
```

### Queries Optimizadas
```python
# Listar fichas con JOIN (1 query, no N+1)
fichas = db.execute("""
    SELECT f.*, r.cliente as raypac_cliente
    FROM dml_fichas f
    LEFT JOIN raypac_entries r ON f.raypac_id = r.id
    ORDER BY f.fecha_ingreso DESC
""").fetchall()

# Stock con alerta pre-calculada
stock = db.execute("""
    SELECT codigo, nombre, cantidad_actual,
    CASE 
        WHEN cantidad_actual = 0 THEN 'ROJO'
        WHEN cantidad_actual = 1 THEN 'AMARILLO'
        WHEN cantidad_actual = 2 THEN 'NARANJA'
        ELSE 'NORMAL'
    END as alerta
    FROM stock_dml
    ORDER BY cantidad_actual ASC
""").fetchall()
```

---

## 📈 ESCALABILIDAD FUTURA

### Mejoras Posibles:
1. **Base de datos**: Migrar a PostgreSQL para multi-usuario concurrente
2. **Frontend**: Usar Vue.js/React para SPA más responsiva
3. **API**: Exponer REST API pública para integraciones
4. **Mobile**: Crear aplicación móvil con Flutter/React Native
5. **Analytics**: Integrar panel de analytics (Grafana, Metabase)
6. **Cloud**: Migrar a AWS/Azure para escalabilidad automática
7. **Cache**: Implementar Redis para sesiones y caching
8. **Async**: Usar Celery para tareas pesadas (PDF generation, emails)

---

## 🧪 TESTING

### Tests Implementados:
- ✅ `smoke_test.py`: Validación completa de BD
- ✅ Validación cliente (JavaScript)
- ✅ Validación servidor (Python)

### Tests Recomendados:
- Unit tests para funciones críticas
- Integration tests para flujos completos
- E2E tests con Selenium/Cypress
- Load tests para verificar concurrencia

---

**Arquitectura diseñada para ser:**
- ✅ Segura (autenticación + auditoría)
- ✅ Escalable (índices, queries optimizadas)
- ✅ Mantenible (código modular, bien documentado)
- ✅ Confiable (backup automático, logging completo)
- ✅ Usable (interfaz intuitiva, responsive)
