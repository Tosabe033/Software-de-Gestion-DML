# 🎯 Sistema DML ST & Gestión de Repuestos

Sistema integral de gestión para reparación de equipos RAYPAC y mantenimiento de stock de repuestos en DML.

**Versión:** 1.0 - Production Ready  
**Estado:** ✅ Completamente funcional  
**Fecha:** 9 de Diciembre de 2025

---

## 🚀 INICIO RÁPIDO

### Paso 1: Activa el entorno virtual
```powershell
cd c:\Users\Andrea\Downloads\dml_sgtec_v3
& .\venv\Scripts\Activate.ps1
```

### Paso 2: Inicia el servidor
```powershell
python app.py
```

### Paso 3: Abre el navegador
```
http://localhost:5000
```

### Paso 4: Login
```
Usuario: admin
Contraseña: admin123
```

**¡Listo! Explora el sistema.**

---

## 📚 DOCUMENTACIÓN PRINCIPAL

### 🎯 Comienza aquí:
- **[PORTADA.md](./PORTADA.md)** - Inicio rápido (2 min)
- **[RESUMEN_EJECUTIVO.md](./RESUMEN_EJECUTIVO.md)** - Para tribunal (5 min)

### 🎬 Para demostración:
- **[GUIA_DEMOSTRACION.md](./GUIA_DEMOSTRACION.md)** - Paso a paso cada feature
- **[CHECKLIST_PRE_PRESENTACION.md](./CHECKLIST_PRE_PRESENTACION.md)** - Verificación pre-tribunal

### 🏗️ Para técnicos:
- **[ARQUITECTURA_TECNICA.md](./ARQUITECTURA_TECNICA.md)** - Diseño BD, API, flujos
- **[CODIGO_FUENTE/app.py](./CODIGO_FUENTE/app.py)** - Código fuente (2350+ líneas)

### 🔧 Para problemas:
- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** - Soluciones a errores

### ✅ Validación:
```powershell
python smoke_test.py
# Resultado: ✅ 13/13 tests PASSED
```

---

## ✨ CARACTERÍSTICAS PRINCIPALES

✅ **RAYPAC:** Ingreso, remito, freezing (bloqueo seguro)  
✅ **DML:** Fichas de reparación, 5 estados, edición completa  
✅ **Repuestos:** Máximo 15 por ficha, stock automático  
✅ **Tickets:** Auto-generados, notificación email  
✅ **Stock:** Dual ubicación (RAYPAC/DML), alertas 3 niveles  
✅ **PDF:** Descargable con 2 columnas profesional  
✅ **🆕 Cierre Ficha:** Botón + email "MÁQUINA LISTA"  
✅ **🆕 Estadísticas:** Dashboard con top 10 y alertas  
✅ **🆕 Ticket Imprimible:** Solapa 2 copias  
✅ **Auditoría:** Registro completo quién/qué/cuándo  

---

## 📊 VALIDACIÓN

### Smoke Test (Automático):
```powershell
python smoke_test.py
```

✅ 13/13 validaciones pasadas:
- RAYPAC ingreso ✓
- RAYPAC freezing ✓
- DML fichas ✓
- Estados reparación ✓
- Tickets ✓
- Repuestos ✓
- Stock ✓
- Estadísticas ✓
- Audit log ✓
- Partes ✓
- Fichas cerradas ✓
- Envíos ✓
- Integridad BD ✓

---

## 📁 Estructura del Proyecto

```
dml_sgtec_v3/
├── DML.exe                          # Ejecutable principal
├── dml.db                           # Base de datos SQLite3
├── app.py                           # Wrapper para ejecutar app
├── launcher.py                      # Wrapper para ejecutar launcher
│
├── DOCUMENTACION_USUARIO/           # Manuales para usuarios finales
│   ├── LEEME_PRIMERO.md
│   ├── MANUAL_USUARIO_COMPLETO.md
│   └── GUIA_RAPIDA_INICIO.md
│
├── DOCUMENTACION_SISTEMA/           # Documentacion tecnica del sistema
│   ├── CHECKLIST_FINAL.md
│   ├── CONFIRMACION_FINAL.md
│   ├── GUIA_EMPAQUETADO_ENVIO.md
│   ├── MANUAL_USUARIO_COMPLETO.md
│   ├── PROYECTO_COMPLETADO.md
│   ├── REPORTE_EJECUTIVO_FINAL.md
│   ├── RESUMEN_FINAL_IMPLEMENTACION.md
│   └── RESPUESTA_PREGUNTAS.md
│
├── DOCUMENTACION_CONTRATO/          # Documentacion del contrato original
│   ├── VERIFICACION_CONTRATO_v1.md
│   └── VERIFICACION_CONTRATO_v2.md
│
├── CODIGO_FUENTE/                   # Codigo fuente del sistema
│   ├── app.py                       # Aplicacion Flask principal
│   ├── launcher.py                  # Interfaz GUI para no tecnicos
│   ├── schema.sql                   # Definicion de BD
│   ├── requirements.txt             # Dependencias
│   ├── build_exe.py                 # Compilacion a .exe
│   ├── compile_exe.py               # Script alternativo
│   ├── load_stock.py                # Carga datos iniciales
│   ├── hash_password.py             # Hashea contrasenas
│   └── show_stats.py                # Muestra estadisticas
│
├── INTERFAZ/                        # Templates HTML y estilos
│   ├── templates/                   # 15 templates Jinja2
│   └── static/                      # CSS y recursos estaticos
│
├── DATOS_INICIALES/                 # Archivos de ejemplo y datos
│   ├── ARCHIVOS_REFERENCIA/         # Excel con 250 items stock
│   └── *.csv                        # Campos de ingreso
│
├── CONFIGURACION/                   # Archivos de configuracion
│   ├── .env.example                 # Plantilla de configuracion
│   └── .env                         # Configuracion actual
│
├── venv/                            # Entorno virtual Python
├── build/                           # Directorios de compilacion (generados)
├── dist/                            # Directorios de compilacion (generados)
│
├── INDICE_DOCUMENTACION.md          # Indice maestro de documentacion
├── SISTEMA_LISTO.md                 # Confirmacion de sistema completo
└── README.md                        # Este archivo
```

## Base de Datos

- **Tipo:** SQLite3 (`dml.db`)
- **Tablas:** 14 tablas
- **Datos iniciales:** 250 items de stock precargados
- **Usuarios:** 5 usuarios de prueba con diferentes roles
- **Registros:** 6 fichas DML, 5 RAYPAC, 32 logs de auditoria

## Modulos del Sistema

### RAYPAC
Gestion de registros RAYPAC con busqueda, edicion y visualizacion detallada.

### DML - Fichas
Registro de fichas tecnicas con campos multiples y vinculacion a stock.

### STOCK
Inventario completo de repuestos con 250 items precargados.

### USUARIOS
Administracion de usuarios con control de acceso por roles (RBAC).

### AUDITORÍA
Registro automatico de cambios para trazabilidad completa.

## Tecnologia

- **Backend:** Python 3.13 + Flask
- **Frontend:** HTML5/CSS3/JavaScript
- **BD:** SQLite3
- **Compilacion:** PyInstaller
- **Seguridad:** Passwords hasheados (PBKDF2), RBAC, CSRF protection

## Cambios Recientes (8 Diciembre 2025)

- Arreglado error de Unicode en launcher.py
- Reorganizacion completa del proyecto en carpetas logicas
- Actualizacion de todas las fechas a 8 de Diciembre 2025
- Creacion de wrappers en raiz para compatibilidad
- README en cada carpeta explicando contenidos

## Soporte

Para problemas o preguntas:
1. Consulta la documentacion en `DOCUMENTACION_USUARIO/`
2. Revisa el manual completo en `DOCUMENTACION_SISTEMA/`
3. Verifica que DML.exe sea de ultima compilacion (15.4 MB)

**Fecha de actualizacion:** 8 de Diciembre de 2025

**Estado:** LISTO PARA DISTRIBUCION
   - Configurable por SMTP (.env)

5. **Cambio de Contraseña**
   - Cada usuario puede cambiar su contraseña
   - Link en menú de perfil

### Configuración de SMTP (Para envío de mails)

Editar `.env`:

```env
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=tu-email@gmail.com
MAIL_PASSWORD=tu-app-password
MAIL_DEFAULT_SENDER=noreply@dml.local
```

**Nota para Gmail:** Usar [App Passwords](https://support.google.com/accounts/answer/185833) en lugar de contraseña normal.

### Tabla de Compatibilidad

| Módulo | Estado | Notas |
|--------|--------|-------|
| Login + Roles | ✅ | Completo con hash de contraseñas |
| Ingresos RAYPAC | ✅ | Con freeze/desbloqueo |
| Fichas DML | ✅ | Con cambio de estado |
| Stock DML | ✅ | Con ABM completo |
| Envío de Mails | ✅ | Configurable por SMTP |
| Usuarios ABM | ✅ | Solo ADMIN |
| Cambio de Contraseña | ✅ | Todos los usuarios |
| Reportes Avanzados | 🔄 | En desarrollo |
| PDF de Fichas | 🔄 | En desarrollo |
| Carga Masiva Repuestos | 🔄 | En desarrollo |

---

## Próximas Mejoras Planeadas 📋

1. **Filtros y Reportes** - Filtrar fichas por estado/cliente/comercial
2. **Generación de PDF** - Descargar ficha como PDF para impresión
3. **Carga Masiva** - Importar matriz de repuestos desde Excel
4. **Auditoría Completa** - Dashboard de logs de cambios

---

## Estructura de Base de Datos

Las nuevas tablas agregadas:
- `audit_log` - Registro de acciones por usuario
- `mail_log` - Registro de mails enviados

Ver `schema.sql` para detalles completos.
