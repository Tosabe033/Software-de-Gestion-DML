# Guía de Instalación y Deployment - Sistema DML ST

## 🚀 Quick Start Local

### Requisitos Previos
- Python 3.7+ instalado
- Git instalado
- Conexión a internet

### Instalación en 5 minutos

```bash
# 1. Clonar repositorio
git clone https://github.com/Tosabe033/Software-de-Gestion-DML.git
cd Software-de-Gestion-DML

# 2. Crear entorno virtual
python -m venv venv

# 3. Activar entorno (Windows)
.\venv\Scripts\Activate.ps1

# 4. Instalar dependencias
pip install -r requirements.txt

# 5. Cargar datos de prueba
python seed_data_minimal.py

# 6. Iniciar servidor
python CODIGO_FUENTE/app.py
```

El sistema estará disponible en **http://localhost:5000**

### Usuarios de Prueba
- **Admin:** admin@dml.local / admin
- **RAYPAC:** raypac@dml.local / raypac
- **DML Técnico:** tecnico@dml.local / tecnico
- **DML Repuestos:** repuestos@dml.local / repuestos

---

## 🌐 Deployment en Render (Recomendado)

### Pasos Rápidos

1. **Ir a https://render.com y crear cuenta**
2. **Conectar GitHub** (autorizar acceso)
3. **Crear Web Service:**
   - Repository: `Tosabe033/Software-de-Gestion-DML`
   - Build Command: `pip install -r requirements-production.txt`
   - Start Command: `gunicorn --chdir CODIGO_FUENTE --bind 0.0.0.0:$PORT app:app`

4. **Agregar Environment Variables:**
   ```
   FLASK_ENV=production
   FLASK_DEBUG=0
   SECRET_KEY=<generar-con-python-secrets>
   ```

5. **Click "Create Web Service"**
6. **Esperar 5-10 minutos**
7. **Tu app estará en:** `https://software-dml.onrender.com`

### Configuración Detallada
Ver archivo: `DEPLOYMENT_RENDER.md`

---

## 📱 Deployment en Railway.app

1. Ir a https://railway.app
2. Click "New Project" → "Deploy from GitHub"
3. Conectar y seleccionar repositorio
4. Configurar:
   - **Root Directory:** `/`
   - **Build Command:** `pip install -r requirements-production.txt`
   - **Start Command:** `gunicorn --chdir CODIGO_FUENTE --bind 0.0.0.0:$PORT app:app`

5. Agregar variables de entorno igual que Render
6. Deploy automático

---

## 🔒 Seguridad en Producción

### ✅ Antes de Deploy

1. **Cambiar SECRET_KEY**
   ```bash
   python -c "import secrets; print(secrets.token_hex(32))"
   ```

2. **Cambiar contraseñas por defecto**
   ```bash
   # Ejecutar localmente primero
   python CODIGO_FUENTE/hash_password.py
   ```

3. **Configurar HTTPS** (Render lo hace automático)

4. **Deshabilitar DEBUG en producción**
   ```
   FLASK_DEBUG=0
   ```

5. **Cambiar BD a PostgreSQL** (para producción real)
   - Más seguro y escalable que SQLite
   - Soporta múltiples usuarios concurrentes

---

## 📊 Monitoreo

### En Render Dashboard
- **Logs en tiempo real**
- **CPU y Memoria**
- **Eventos de deploy**
- **Alertas automáticas**

### Integración de Error Tracking (Sentry)
```bash
pip install sentry-sdk
```

Agregar en `app.py`:
```python
import sentry_sdk
sentry_sdk.init("your-sentry-dsn")
```

---

## 🔄 Auto-Deploy

Cada push a `main` dispara automáticamente:
1. Build (instalar dependencias)
2. Test (si hay tests)
3. Deploy (reemplazar versión anterior)
4. Restart automático

---

## 🗄️ Base de Datos

### Local (SQLite)
- Archivo: `dml.db`
- Auto-creada en primer uso
- Perfecta para testing

### Producción (PostgreSQL en Render)
1. En Render: Add Database → PostgreSQL
2. Copiar CONNECTION STRING
3. Instalar: `pip install psycopg2-binary`
4. Cambiar en app.py:
   ```python
   db_url = os.getenv('DATABASE_URL')
   # Cambiar de SQLite a PostgreSQL
   ```

---

## 📞 Soporte y Troubleshooting

### Problema: "Build failed"
- Revisar logs en Render
- Verificar `requirements-production.txt`
- Asegurar Procfile está en raíz

### Problema: "503 Service Unavailable"
- App está iniciando (tarda 30-60 segundos)
- Revisar logs para errores

### Problema: "Modificar variables de entorno"
- Render → Settings → Environment
- Cambiar variable
- Redeploy automático

### Problema: "BD no persiste"
- En free tier, BD se reinicia con deploys
- Para producción: usar PostgreSQL en Render

---

## 📚 Documentación Adicional

- **Manual de Usuario:** `DOCUMENTACION_SOFTWARE/MANUAL_USUARIO_DAVID.md`
- **Arquitectura Técnica:** `CODIGO_FUENTE/DOCUMENTACION_SOFTWARE/ARQUITECTURA_TECNICA.md`
- **Guía de Demostración:** `CODIGO_FUENTE/DOCUMENTACION_SOFTWARE/GUIA_DEMOSTRACION.md`

---

**Última actualización:** 9 de Diciembre de 2025  
**Versión:** 1.0 - Production Ready
