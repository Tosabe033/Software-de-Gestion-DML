PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS mail_log;
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS envios_repuestos_detalles;
DROP TABLE IF EXISTS envios_repuestos;
DROP TABLE IF EXISTS repuestos_faltantes;
DROP TABLE IF EXISTS dml_repuestos;
DROP TABLE IF EXISTS dml_partes;
DROP TABLE IF EXISTS dml_fichas;
DROP TABLE IF EXISTS stock_ubicaciones;
DROP TABLE IF EXISTS stock_dml;
DROP TABLE IF EXISTS matriz_repuestos;
DROP TABLE IF EXISTS raypac_entries;
DROP TABLE IF EXISTS users;

-- Tabla de Usuarios
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    nombre TEXT,
    role TEXT NOT NULL,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Tabla RAYPAC - Ingreso inicial
CREATE TABLE raypac_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_correlativo INTEGER,
    fecha_recepcion TEXT NOT NULL,
    tipo_solicitud TEXT NOT NULL,
    cliente TEXT NOT NULL,
    numero_serie TEXT NOT NULL UNIQUE,
    modelo_maquina TEXT NOT NULL,
    tipo_maquina TEXT NOT NULL,
    numero_bateria TEXT,
    numero_cargador TEXT,
    diagnostico_ingreso TEXT,
    comercial TEXT NOT NULL,
    mail_comercial TEXT NOT NULL,
    numero_remito TEXT,
    is_frozen INTEGER NOT NULL DEFAULT 0,
    frozen_at TEXT,
    unfrozen_by TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Matriz de Repuestos (catálogo)
CREATE TABLE matriz_repuestos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero INTEGER NOT NULL,
    codigo_repuesto TEXT NOT NULL UNIQUE,
    item TEXT NOT NULL,
    cantidad_inicial INTEGER NOT NULL,
    cantidad_actual INTEGER NOT NULL,
    ubicacion TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Stock DML (inventario general)
CREATE TABLE stock_dml (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo_repuesto TEXT NOT NULL UNIQUE,
    item TEXT,
    cantidad INTEGER NOT NULL DEFAULT 0,
    cantidad_minima INTEGER DEFAULT 2,
    estado_alerta TEXT DEFAULT 'OK',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(codigo_repuesto) REFERENCES matriz_repuestos(codigo_repuesto)
);

-- Stock por Ubicación (RAYPAC y DML)
CREATE TABLE stock_ubicaciones (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo_repuesto TEXT NOT NULL,
    ubicacion TEXT NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(codigo_repuesto, ubicacion),
    FOREIGN KEY(codigo_repuesto) REFERENCES matriz_repuestos(codigo_repuesto)
);

-- Tabla DML Fichas - Servicio Técnico
CREATE TABLE dml_fichas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_ficha INTEGER UNIQUE NOT NULL,
    raypac_id INTEGER NOT NULL,
    fecha_ingreso TEXT NOT NULL,
    tecnico TEXT NOT NULL,
    numero_ticket TEXT UNIQUE,
    diagnostico_inicial TEXT,
    diagnostico_reparacion TEXT,
    observaciones TEXT,
    estado_reparacion TEXT DEFAULT 'A LA ESPERA DE REVISIÓN',
    n_ciclos INTEGER,
    mecanizado_adic TEXT,
    horas_adic REAL,
    tipo_trabajo TEXT NOT NULL DEFAULT 'REPARACIÓN',
    tecnico_resp TEXT NOT NULL,
    fecha_egreso TEXT,
    numero_remito_salida TEXT,
    is_closed INTEGER NOT NULL DEFAULT 0,
    closed_at TEXT,
    ticket_enviado INTEGER DEFAULT 0,
    ficha_generada INTEGER DEFAULT 0,
    pdf_ficha BLOB,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(raypac_id) REFERENCES raypac_entries(id) ON DELETE CASCADE
);

-- Partes del Equipo (12 partes estándar)
CREATE TABLE dml_partes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ficha_id INTEGER NOT NULL,
    nombre_parte TEXT NOT NULL,
    estado TEXT NOT NULL,
    FOREIGN KEY(ficha_id) REFERENCES dml_fichas(id) ON DELETE CASCADE
);

-- Repuestos Utilizados en Reparación (hasta 15)
CREATE TABLE dml_repuestos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ficha_id INTEGER NOT NULL,
    codigo_repuesto TEXT NOT NULL,
    descripcion TEXT,
    cantidad INTEGER NOT NULL DEFAULT 1,
    cantidad_utilizada INTEGER DEFAULT 1,
    estado_repuesto TEXT DEFAULT 'INSPECCIONADO',
    en_stock INTEGER DEFAULT 0,
    en_falta INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(ficha_id) REFERENCES dml_fichas(id) ON DELETE CASCADE
);

-- Repuestos Faltantes en Transición
CREATE TABLE repuestos_faltantes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ficha_id INTEGER NOT NULL,
    codigo_repuesto TEXT NOT NULL,
    descripcion TEXT,
    cantidad INTEGER NOT NULL,
    fecha_falta TEXT DEFAULT CURRENT_TIMESTAMP,
    fecha_llegada TEXT,
    FOREIGN KEY(ficha_id) REFERENCES dml_fichas(id) ON DELETE CASCADE
);

-- Envios de Repuestos RAYPAC a DML
CREATE TABLE envios_repuestos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_remito TEXT UNIQUE NOT NULL,
    fecha_envio TEXT NOT NULL,
    fecha_recepcion TEXT,
    estado TEXT DEFAULT 'PENDIENTE',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Detalles de Envios
CREATE TABLE envios_repuestos_detalles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    envio_id INTEGER NOT NULL,
    codigo_repuesto TEXT NOT NULL,
    cantidad INTEGER NOT NULL,
    FOREIGN KEY(envio_id) REFERENCES envios_repuestos(id) ON DELETE CASCADE
);

-- Auditoría
CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    action TEXT NOT NULL,
    table_name TEXT NOT NULL,
    record_id INTEGER,
    old_value TEXT,
    new_value TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

-- Log de Correos
CREATE TABLE mail_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ficha_id INTEGER,
    recipient TEXT NOT NULL,
    subject TEXT,
    body TEXT,
    sent_at TEXT DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'sent',
    FOREIGN KEY(ficha_id) REFERENCES dml_fichas(id)
);

-- ======================== NUEVAS TABLAS PARA REQUERIMIENTOS ========================

-- Tickets de Seguimiento
CREATE TABLE tickets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_ticket TEXT UNIQUE NOT NULL,
    ficha_id INTEGER NOT NULL,
    numero_serie TEXT NOT NULL,
    estado TEXT DEFAULT 'ACTIVO',
    fecha_creacion TEXT DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(ficha_id) REFERENCES dml_fichas(id) ON DELETE CASCADE,
    UNIQUE(numero_ticket)
);

-- Historial de Seguimiento de Tickets
CREATE TABLE ticket_historial (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ticket_id INTEGER NOT NULL,
    estado_anterior TEXT,
    estado_nuevo TEXT NOT NULL,
    motivo TEXT,
    usuario_id INTEGER,
    fecha TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
    FOREIGN KEY(usuario_id) REFERENCES users(id)
);

-- Alertas de Stock
CREATE TABLE stock_alertas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo_repuesto TEXT NOT NULL,
    item TEXT,
    cantidad_actual INTEGER,
    nivel_alerta TEXT NOT NULL,
    email_enviado INTEGER DEFAULT 0,
    fecha_alerta TEXT DEFAULT CURRENT_TIMESTAMP,
    fecha_resuelto TEXT,
    FOREIGN KEY(codigo_repuesto) REFERENCES matriz_repuestos(codigo_repuesto)
);

-- Estadísticas de Repuestos (salida/movimiento)
CREATE TABLE estadisticas_repuestos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo_repuesto TEXT NOT NULL,
    item TEXT,
    cantidad_utilizada INTEGER DEFAULT 0,
    fecha_ultimo_uso TEXT,
    total_usos INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(codigo_repuesto) REFERENCES matriz_repuestos(codigo_repuesto)
);

-- Freezing/Desfreeze de Registros
CREATE TABLE freezing_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tabla_nombre TEXT NOT NULL,
    registro_id INTEGER NOT NULL,
    estado_freezing INTEGER NOT NULL,
    usuario_freeze INTEGER,
    fecha_freeze TEXT,
    usuario_unfreeze INTEGER,
    fecha_unfreeze TEXT,
    motivo_unfreeze TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(usuario_freeze) REFERENCES users(id),
    FOREIGN KEY(usuario_unfreeze) REFERENCES users(id)
);

-- ======================== STOCK INICIAL ========================

INSERT INTO matriz_repuestos (numero, codigo_repuesto, item, cantidad_inicial, cantidad_actual, ubicacion) VALUES
(1, 'A000001', 'CARCAZA FRONTAL', 5, 5, 'DML'),
(2, 'A000002', 'CARCAZA TRASERA', 5, 5, 'DML'),
(3, 'A000003', 'TENSION MOTOR PRINCIPAL', 3, 3, 'DML'),
(4, 'A000004', 'TENSION MOTOR SECUNDARIO', 3, 3, 'DML'),
(5, 'B000001', 'BATERIA LITIO ITA24', 8, 8, 'DML'),
(6, 'B000002', 'BATERIA NIQUEL ITA10', 5, 5, 'DML'),
(7, 'C000001', 'CARGADOR RAPIDO', 4, 4, 'DML'),
(8, 'C000002', 'CABLE USB', 10, 10, 'DML'),
(9, 'M000001', 'MOTOR ARRASTRE PRINCIPAL', 2, 2, 'DML'),
(10, 'M000002', 'MOTOR ARRASTRE SECUNDARIO', 2, 2, 'DML'),
(11, 'S000001', 'SERVO MOTOR IZQUIERDO', 3, 3, 'DML'),
(12, 'S000002', 'SERVO MOTOR DERECHO', 3, 3, 'DML'),
(13, 'E000001', 'EJE RUEDA DELANTERA', 2, 2, 'DML'),
(14, 'E000002', 'EJE RUEDA TRASERA', 2, 2, 'DML'),
(15, 'R000001', 'RESORTE MANIJA IZQUIERDA', 4, 2, 'DML'),
(16, 'R000002', 'RESORTE MANIJA DERECHA', 4, 3, 'DML'),
(17, 'K000001', 'KIT COMPLETO CUCHILLAS', 6, 6, 'DML'),
(18, 'K000002', 'KIT SELLADO MOTOR', 3, 3, 'DML'),
(19, 'P000001', 'PULSADOR INICIO', 8, 8, 'DML'),
(20, 'P000002', 'PULSADOR PARADA', 8, 8, 'DML');

INSERT INTO stock_dml (codigo_repuesto, item, cantidad, cantidad_minima, estado_alerta) VALUES
('A000001', 'CARCAZA FRONTAL', 5, 2, 'OK'),
('A000002', 'CARCAZA TRASERA', 5, 2, 'OK'),
('A000003', 'TENSION MOTOR PRINCIPAL', 3, 2, 'OK'),
('A000004', 'TENSION MOTOR SECUNDARIO', 3, 2, 'OK'),
('B000001', 'BATERIA LITIO ITA24', 8, 3, 'OK'),
('B000002', 'BATERIA NIQUEL ITA10', 5, 2, 'OK'),
('C000001', 'CARGADOR RAPIDO', 4, 2, 'OK'),
('C000002', 'CABLE USB', 10, 5, 'OK'),
('M000001', 'MOTOR ARRASTRE PRINCIPAL', 2, 1, 'AMARILLO'),
('M000002', 'MOTOR ARRASTRE SECUNDARIO', 2, 1, 'AMARILLO'),
('S000001', 'SERVO MOTOR IZQUIERDO', 3, 2, 'OK'),
('S000002', 'SERVO MOTOR DERECHO', 3, 2, 'OK'),
('E000001', 'EJE RUEDA DELANTERA', 2, 1, 'AMARILLO'),
('E000002', 'EJE RUEDA TRASERA', 2, 1, 'AMARILLO'),
('R000001', 'RESORTE MANIJA IZQUIERDA', 2, 2, 'AMARILLO'),
('R000002', 'RESORTE MANIJA DERECHA', 3, 2, 'OK'),
('K000001', 'KIT COMPLETO CUCHILLAS', 6, 3, 'OK'),
('K000002', 'KIT SELLADO MOTOR', 3, 2, 'OK'),
('P000001', 'PULSADOR INICIO', 8, 4, 'OK'),
('P000002', 'PULSADOR PARADA', 8, 4, 'OK');

INSERT INTO stock_ubicaciones (codigo_repuesto, ubicacion, cantidad) VALUES
('A000001', 'DML', 5),
('A000002', 'DML', 5),
('A000003', 'DML', 3),
('A000004', 'DML', 3),
('B000001', 'DML', 8),
('B000002', 'DML', 5),
('C000001', 'DML', 4),
('C000002', 'DML', 10);

-- ======================== USUARIOS INICIALES ========================

INSERT INTO users (email, password_hash, nombre, role, is_active) VALUES
('admin@dml.local', 'scrypt:32768:8:1$C1GodCQmP4TPBzdu$d7431487bc1f7b787ed0a6a8e2bfc23b6126159af237edddc373e56f4ea1b5dc97e1ae17d964bb0d14710740f186b0816d544468e15884da871822071202df5b', 'Administrador', 'ADMIN', 1),
('raypac@dml.local', 'scrypt:32768:8:1$INW4lIB70TLXFrnH$038473a5723a545f9fb7d5e6bf76b0aa9f6869d925a446c11260b3a7ed5981c271b4c38efc231c5da233d57c4bef761a849a8d0eac082990eb5aed4b47c6d6bf', 'RAYPAC', 'RAYPAC', 1),
('st@dml.local', 'scrypt:32768:8:1$cnwNhU4tbsxdpC05$2ab29b9d5d811c4557804e9b34553d4942a224fb6815cffc0455863e79800b8d6dc44f17c6f0caaf0eac7d7181a8f4775d7b3af48a8a83e2674dc6d323de046e', 'Servicio Técnico', 'DML_ST', 1),
('repuestos@dml.local', 'scrypt:32768:8:1$smR33nKhNscjpIS6$27908a73bb88135ad531fca333ff836afb0ff8ec887b2f711aa1997c315d9aad7e7bfa685fd5ab714305934c0889bd9fd078a6350158a7c5811481e6552c26dc', 'Repuestos', 'DML_REPUESTOS', 1);
