# 🔧 TROUBLESHOOTING Y FAQ
## Soluciones rápidas para problemas comunes

---

## ❓ PROBLEMAS COMUNES Y SOLUCIONES

### 1. "No se conecta a http://localhost:5000"

**Síntoma:** Error de conexión, página no encontrada

**Causa probable:** Servidor Flask no está ejecutándose

**Solución:**
```powershell
# 1. Abre PowerShell como administrador
# 2. Navega a la carpeta
cd c:\Users\Andrea\Downloads\dml_sgtec_v3

# 3. Activa virtualenv
& .\venv\Scripts\Activate.ps1

# 4. Inicia servidor
python app.py

# Deberías ver:
# * Running on http://127.0.0.1:5000
```

**Si aún no funciona:**
- ¿Está el puerto 5000 ocupado? → Cambia en app.py: `app.run(debug=True, port=5001)`
- ¿Tiene permisos? → Ejecuta PowerShell como Admin
- ¿Está Python instalado? → `python --version`

---

### 2. "Error: ModuleNotFoundError: No module named 'flask'"

**Síntoma:** Al ejecutar `python app.py`, error de módulo

**Causa probable:** Virtualenv no activado o dependencias no instaladas

**Solución:**
```powershell
# 1. Activa virtualenv
cd c:\Users\Andrea\Downloads\dml_sgtec_v3
& .\venv\Scripts\Activate.ps1

# 2. Instala dependencias
pip install -r requirements.txt

# 3. Verifica instalación
pip list | grep -i flask

# 4. Intenta nuevamente
python app.py
```

**Si sigue fallando:**
```powershell
# Recrea virtualenv
python -m venv venv
& .\venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install -r requirements.txt
```

---

### 3. "Login no funciona - Usuario/Contraseña incorrecto"

**Síntoma:** No puedo ingresar aunque uso `admin` / `admin123`

**Causa probable:** BD corrupta o usuario no existe

**Solución:**
```powershell
# 1. Detén servidor (Ctrl+C)
# 2. Borra la BD
cd c:\Users\Andrea\Downloads\dml_sgtec_v3
del dml_database.db

# 3. Reinicia servidor (crea BD nueva)
python app.py

# 4. La BD se crea automáticamente con usuario admin

# Si sigue sin funcionar, verifica en app.py:
# Busca: "def init_db()" - asegúrate que crea usuario admin
```

---

### 4. "Error al agregar repuesto: Clave duplicada"

**Síntoma:** No puedo agregar un repuesto que ya existe

**Causa probable:** Ya existe ese código en BD

**Solución:**
```
1. Usa código diferente (el sistema auto-genera)
2. O si quieres editar stock existente:
   - Busca el repuesto en /stock
   - Click "Editar"
   - Modifica cantidad
```

---

### 5. "No se genera PDF, error blank page"

**Síntoma:** Click en "Descargar PDF" no funciona

**Causa probable:** Repuesto sin código válido o BD inconsistente

**Solución:**
```powershell
# 1. Abre navegador developer tools (F12)
# 2. Ve a Console y busca errores
# 3. En app.py, verifica que la ficha tiene repuestos:
#    SELECT * FROM dml_repuestos WHERE ficha_id = [ID];

# 4. Prueba agregando repuesto primero:
#    - Editar ficha
#    - Agregar repuesto válido
#    - Intentar descargar PDF nuevamente
```

---

### 6. "Email no se envía"

**Síntoma:** Cierro ficha pero no llega email

**Causa probable:** SMTP no configurado correctamente

**Solución:**
```python
# En app.py, busca:
# def send_mail(destinatario, asunto, body_html):

# Verificar que esté así:
mail.default_sender = os.getenv('MAIL_FROM', 'noreply@dml.com')

# Si quieres que funcione:
# 1. Crear archivo .env en raíz:
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=tu_email@gmail.com
MAIL_PASSWORD=tu_app_password
MAIL_DEFAULT_SENDER=tu_email@gmail.com

# 2. Pero ATENCIÓN: Gmail requiere "app password" (no contraseña normal)
#    Ver: https://myaccount.google.com/apppasswords

# Por ahora, el sistema funciona sin email (es no-crítico)
```

**Nota:** Email es integración, no crítica para operación. Sistema funciona sin él.

---

### 7. "Stock no se actualiza al agregar repuesto"

**Síntoma:** Agrego repuesto a ficha pero stock sigue igual

**Causa probable:** Código de repuesto no existe en stock general

**Solución:**
```
1. Primero crea el repuesto en STOCK (/stock/new)
   Password: ADMIN2024
   
2. Luego agrega a ficha
   
3. Stock descuenta automáticamente

Si ya existe pero no descuenta:
- Verifica que el "código" exacto coincida
- Caso-sensible: "RBMS0001" ≠ "rbms0001"
```

---

### 8. "Ficha no se puede editar - Dice 'Bloqueada'"

**Síntoma:** Al intentar editar, no deja cambiar campos

**Causa probable:** Ficha está freezada o cerrada (is_closed=1)

**Solución:**
```
Si está freezada (RAYPAC):
- Click "Desfreezar"
- Ingresa numero_remito
- Click "Desbloquear"

Si está cerrada (DML - is_closed=1):
- Es intencional, no se puede editar ficha finalizada
- Para reabrir, requiere admin en BD directamente
  (O contactar administrador)
```

---

### 9. "Validación JS bloquea agregar repuesto válido"

**Síntoma:** Mensaje "Repuesto ya existe en ficha" pero no está

**Causa probable:** Código de repuesto está en la ficha pero oculto o con espacios

**Solución:**
```
1. Actualiza página (F5)
2. Verifica lista de repuestos actual
3. Si el repuesto está listado:
   - Busca el que marcaste como "en falta"
   - Elimina la fila
   - Intenta agregar nuevamente

4. Si se insiste el error:
   - Abre console (F12 → Console)
   - Ejecuta: document.querySelectorAll('input[name="codigo"]').forEach(e => console.log(e.value))
   - Esto muestra todos los códigos actuales
```

---

### 10. "Base de datos corrupta - BD no abre"

**Síntoma:** Error al iniciar servidor, "database disk image is malformed"

**Causa probable:** Proceso anterior terminó abruptamente

**Solución:**
```powershell
# 1. Detén servidor (Ctrl+C)

# 2. Elimina BD corrupta
cd c:\Users\Andrea\Downloads\dml_sgtec_v3
Remove-Item dml_database.db -Force

# 3. Reinicia servidor (crea BD nueva automáticamente)
python app.py

# 4. Se recrea con datos de prueba

# Nota: Se pierden cambios. Para evitar:
# - Hacer backup antes (copiar dml_database.db)
```

---

## 🔍 DEBUGGING AVANZADO

### Ver logs en tiempo real:
```python
# En app.py, activa debug logging
import logging
logging.basicConfig(level=logging.DEBUG)

# Reinicia servidor
python app.py

# Verás todos los queries SQL ejecutados
```

### Inspeccionar BD directamente:
```powershell
# Usar SQLite browser
# Descargar de: https://sqlitebrowser.org/

# O en terminal:
cd c:\Users\Andrea\Downloads\dml_sgtec_v3
python

# Dentro de Python:
import sqlite3
conn = sqlite3.connect('dml_database.db')
cursor = conn.cursor()

# Ver tablas
cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
for row in cursor.fetchall():
    print(row)

# Ver datos
cursor.execute("SELECT COUNT(*) FROM dml_fichas;")
print(cursor.fetchone())

# Ver schema
cursor.execute("PRAGMA table_info(dml_fichas);")
for row in cursor.fetchall():
    print(row)
```

### Limpiar caché del navegador:
```
1. Chrome: Ctrl+Shift+Delete
2. Firefox: Ctrl+Shift+Delete
3. Edge: Ctrl+Shift+Delete
4. Selecciona "Todas las cookies y datos del sitio"
5. Elimina
6. Recarga página (Ctrl+F5)
```

---

## 🎯 CHECKLIST DE DIAGNÓSTICO

Si algo no funciona:

- [ ] ¿Servidor Flask ejecutándose? (`python app.py` en terminal)
- [ ] ¿Puerto 5000 disponible? (Si no, cambia en app.py)
- [ ] ¿Virtualenv activado? (`& .\venv\Scripts\Activate.ps1`)
- [ ] ¿Dependencias instaladas? (`pip list | grep flask`)
- [ ] ¿BD existe? (`ls dml_database.db`)
- [ ] ¿BD no corrupta? (Elimina y recrea si es necesario)
- [ ] ¿Usuario logueado? (Login primero en `/`)
- [ ] ¿Rol correcto?  (ADMIN acceso full, otros limitados)
- [ ] ¿Datos existen? (En `/dml`, `/raypac`, etc.)
- [ ] ¿Caché limpio? (F5 o Ctrl+Shift+Del)
- [ ] ¿JavaScript habilitado? (Necesario para validaciones)
- [ ] ¿Console sin errores? (F12 → Console)

---

## 📞 DATOS DE CONTACTO

**Usuario admin default:**
```
Usuario: admin
Contraseña: admin123
```

**Acceso principal:**
```
http://localhost:5000
```

**Archivos críticos:**
```
CODIGO_FUENTE/app.py          - Lógica principal (2350 líneas)
INTERFAZ/templates/           - Vistas HTML (20+ archivos)
INTERFAZ/static/              - Assets (CSS, images)
dml_database.db               - Base de datos SQLite
requirements.txt              - Dependencias Python
```

---

## 🎓 REFERENCIAS RÁPIDAS

### Estructura de carpetas:
```
dml_sgtec_v3/
├── CODIGO_FUENTE/
│   └── app.py              # Punto de entrada
├── INTERFAZ/
│   ├── templates/          # Vistas HTML
│   └── static/             # CSS, images
├── venv/                   # Virtualenv
├── dml_database.db         # Base de datos
├── requirements.txt        # Dependencias
├── README.md              # Documentación
└── RESUMEN_EJECUTIVO.md   # Este proyecto
```

### URLs principales:
```
http://localhost:5000/                      Dashboard
http://localhost:5000/raypac                RAYPAC
http://localhost:5000/dml                   DML Fichas
http://localhost:5000/stock                 Stock
http://localhost:5000/tickets               Tickets
http://localhost:5000/estadisticas          Estadísticas
http://localhost:5000/usuarios              Usuarios (ADMIN)
```

---

## ✅ VERIFICACIÓN RÁPIDA

Para verificar que TODO funciona:

```powershell
# 1. Abre terminal
# 2. Ejecuta smoke test
cd c:\Users\Andrea\Downloads\dml_sgtec_v3
& .\venv\Scripts\Activate.ps1
python smoke_test.py

# Deberías ver:
# TEST 1: INGRESO RAYPAC ✓
# TEST 2: RAYPAC CON REMITO ✓
# ...
# TEST 13: INTEGRIDAD DE BD ✓
```

Si todos pasan: ✅ **Sistema 100% funcional**

---

**Última actualización:** 9 de Diciembre de 2025  
**Versión:** 1.0 (Production Ready)  
**Soporte:** Ver documentación incluida (REPORTE_FINAL.md, GUIA_DEMOSTRACION.md, ARQUITECTURA_TECNICA.md)
