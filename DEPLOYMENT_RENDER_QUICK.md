# 🚀 INICIO RÁPIDO - DEPLOYMENT EN RENDER (5 MINUTOS)

## Paso 1: Preparar SECRET_KEY

En tu computadora, abre PowerShell y genera una clave:

```powershell
python -c "import secrets; print(secrets.token_hex(32))"
```

Copia el resultado. Ejemplo:
```
a3b4c5d6e7f8g9h0i1j2k3l4m5n6o7p8q9r0s1t2u3v4w5x6y7z8
```

---

## Paso 2: Crear cuenta en Render

1. Ve a https://render.com
2. Click en **"Sign up"**
3. Elige **"Continue with GitHub"**
4. Autoriza el acceso a tus repositorios
5. Verifica tu email

---

## Paso 3: Conectar Repositorio

1. En Render Dashboard, click en **"New +"**
2. Selecciona **"Web Service"**
3. En "Connect a repository", busca: `Software-de-Gestion-DML`
4. Click en **"Connect"**

---

## Paso 4: Configurar el Servicio

### Nombre del Servicio
```
software-dml
```

### Region
```
Estados Unidos (us-east-1) - Más rápido desde América Latina
```

### Environment
```
Python 3.11
```

### Build Command
```bash
pip install -r requirements-production.txt
```

### Start Command
```bash
gunicorn --chdir CODIGO_FUENTE --bind 0.0.0.0:$PORT app:app
```

---

## Paso 5: Agregar Variables de Entorno

Scroll down a **"Environment"**

Click en **"Add Environment Variable"** y agrega:

### 1. FLASK_ENV
```
Key: FLASK_ENV
Value: production
```

### 2. FLASK_DEBUG
```
Key: FLASK_DEBUG
Value: 0
```

### 3. SECRET_KEY (LA CLAVE QUE GENERASTE)
```
Key: SECRET_KEY
Value: a3b4c5d6e7f8g9h0i1j2k3l4m5n6o7p8q9r0s1t2u3v4w5x6y7z8
```

Repite esto 3 veces hasta tener las 3 variables.

---

## Paso 6: Deploy

1. Scroll down hasta el botón azul
2. Click en **"Create Web Service"**
3. **Espera 5-10 minutos** mientras Render construye la app
4. Verás una URL como: `https://software-dml.onrender.com`

---

## Paso 7: Verificar

Una vez completado el deploy:

1. Abre la URL en tu navegador
2. Deberías ver el login
3. Intenta login con:
   - Email: `admin@dml.local`
   - Contraseña: `admin`

Si ves la página de login → ¡**Éxito! Tu app está en producción** 🎉

---

## 🔄 Auto-Deploy

Ahora cada vez que hagas `git push` a `main`:

```bash
git add .
git commit -m "Mi cambio"
git push origin main
```

Render automáticamente:
1. Descarga los cambios
2. Reconstruye la app (3-5 min)
3. Redeploy sin downtime

Verás en el dashboard de Render.

---

## 🐛 Si algo falla

### Error: "Build failed"
- Abre **"Logs"** en Render
- Busca el mensaje de error
- Verifica que `requirements-production.txt` esté actualizado
- Intenta redeploy manualmente

### Error: "503 Service Unavailable"
- Es normal los primeros segundos
- Espera 30-60 segundos
- La BD se está inicializando

### Error: "ModuleNotFoundError"
- Asegúrate que el módulo está en `requirements-production.txt`
- Verifica la ortografía exacta

---

## 📊 Monitorear tu App

En el dashboard de Render:

- **Logs:** Ver qué está pasando en tiempo real
- **CPU/Memory:** Uso de recursos
- **Network:** Tráfico
- **Events:** Historial de deploys

---

## 🎯 Próximos Pasos (Opcional)

### Agregar Dominio Propio
1. Render → **Settings** → **Custom Domain**
2. Seguir instrucciones DNS
3. Ejemplo: `dml.tudominio.com`

### Cambiar a PostgreSQL (Producción)
1. Render → **New +** → **PostgreSQL**
2. Copiar Connection String
3. Agregar variable: `DATABASE_URL`
4. Cambiar BD de SQLite a PostgreSQL en `app.py`

### Configurar Email Automático
1. Usar SendGrid o Mailgun
2. Agregar variables de entorno
3. Configurar en `app.py`

---

## ✅ Checklist

- [ ] SECRET_KEY generado
- [ ] Cuenta Render creada
- [ ] Repositorio conectado
- [ ] Variables de entorno agregadas
- [ ] Deploy completado
- [ ] Login funciona en producción
- [ ] Datos visibles en la app
- [ ] Compartir URL con David

---

## 📞 Soporte

**Si algo no funciona:**

1. Revisa los logs en Render
2. Compara con `DEPLOYMENT_RENDER.md`
3. Intenta redeploy manual
4. Contacta a: desarrollo@dml.local

---

**¡Tu app estará en producción en menos de 10 minutos!** 🚀
