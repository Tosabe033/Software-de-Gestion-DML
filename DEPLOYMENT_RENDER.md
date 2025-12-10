# Render Deployment Guide - Sistema DML ST & Gestión de Repuestos

## 🚀 Pasos para Deploying en Render

### 1. Crear Cuenta en Render
1. Ir a https://render.com
2. Click en "Sign up"
3. Conectar con GitHub (recomendado)
4. Autorizar acceso a tus repositorios

### 2. Crear Web Service
1. Dashboard → Click en "New +"
2. Seleccionar "Web Service"
3. Conectar repositorio: `Tosabe033/Software-de-Gestion-DML`
4. Seleccionar rama: `main`

### 3. Configuración del Servicio

**Nombre:**
```
Software-DML
```

**Environment:**
```
Python 3.11
```

**Build Command:**
```bash
pip install -r requirements-production.txt && python CODIGO_FUENTE/app.py --version
```

**Start Command:**
```bash
gunicorn --chdir CODIGO_FUENTE --bind 0.0.0.0:$PORT app:app
```

### 4. Variables de Entorno
En la sección "Environment" agregar:

```
FLASK_ENV=production
FLASK_DEBUG=0
SECRET_KEY=tu-clave-secreta-muy-larga-y-aleatoria-aqui
DATABASE_URL=sqlite:///dml.db
```

**Para generar SECRET_KEY segura:**
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

### 5. Plan y Límites
- **Plan Free:** 0.5 GB RAM, suficiente para testing
- **Plan Paid:** Desde $7/mes para producción
- La BD SQLite se guarda automáticamente en `/var/data/`

### 6. Conectar Dominio (Opcional)
1. En el dashboard del servicio → "Settings"
2. Ir a "Custom Domain"
3. Agregar tu dominio y seguir instrucciones DNS

### 7. Auto-Deploy
- Cada push a `main` en GitHub dispara deploy automático
- Ver logs en tiempo real desde Render dashboard

---

## 📋 Alternativas a Render

### Railway.app
Similar a Render, excelente UX:
1. https://railway.app
2. Conectar GitHub
3. Configurar las mismas variables de entorno
4. Deploy automático

### PythonAnywhere
Para aplicaciones Flask simples:
1. https://www.pythonanywhere.com
2. Subir código manualmente
3. Configurar app web
4. Menos código pero más manual

---

## 🔧 Troubleshooting Deploy

### Error: "ModuleNotFoundError: No module named 'flask'"
**Solución:** Verificar que `Build Command` ejecute `pip install -r requirements-production.txt`

### Error: "Address already in use"
**Solución:** Render maneja puertos automáticamente con variable `$PORT`

### Base de datos no se persiste
**Solución:** En Render free, BD se pierde al redeploy. Para producción usar:
- PostgreSQL en Render (mejor opción)
- MongoDB Atlas (alternativa)

### App tardía al iniciar
**Normal:** Primera vez tarda 30-60 segundos. Usar `requirements-production.txt` para cachéo.

---

## 📝 Pasos Rápidos (Resumen)

1. **Crear cuenta en Render.com**
2. **Conectar tu repo GitHub**
3. **Crear Web Service**
4. **Agregar variables de entorno (SECRET_KEY, FLASK_ENV)**
5. **Build Command:** `pip install -r requirements-production.txt`
6. **Start Command:** `gunicorn --chdir CODIGO_FUENTE --bind 0.0.0.0:$PORT app:app`
7. **Click "Create Web Service"**
8. **Esperar 5-10 minutos a que se complete**
9. **Tu app estará en:** `https://software-dml.onrender.com` (o tu dominio)

---

## 🎯 Próximas Mejoras para Producción

### Migrar a PostgreSQL
```bash
pip install psycopg2-binary
# Cambiar conexión en app.py a PostgreSQL
```

### Configurar SSL/HTTPS
- Render lo hace automático ✅

### Backup de BD
- Configurar snapshots automáticos

### Monitoreo y Logs
- Render proporciona logs en tiempo real
- Integración con Sentry para error tracking

### Email Automático
- Configurar SendGrid o Mailgun en lugar de SMTP local

---

## ✅ Checklist Pre-Deploy

- [ ] Código en GitHub (main branch)
- [ ] requirements-production.txt actualizado
- [ ] Procfile configurado
- [ ] Variables de entorno definidas
- [ ] DB SQLite funciona localmente
- [ ] Seed data cargado
- [ ] Todos los tests pasan
- [ ] README.md actualizado

---

**Última actualización:** 9 de Diciembre de 2025
