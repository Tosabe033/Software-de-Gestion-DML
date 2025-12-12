# 📧 CONFIGURACIÓN DE EMAILS - SISTEMA DML

## ⚠️ IMPORTANTE - PENDIENTE DE CONFIGURACIÓN

El sistema está preparado para enviar emails automáticos, pero **requiere configuración de credenciales SMTP**.

---

## 📨 Funcionalidades de Email Actuales

Una vez configurado, el sistema enviará automáticamente:

1. **Ticket de seguimiento** → Al comercial RAYPAC cuando DML crea una ficha
2. **Máquina lista para retirar** → Al comercial cuando se genera el PDF final
3. **Confirmación de recepción de repuestos** → A RAYPAC cuando DML recibe envío
4. **Alertas de stock bajo** → Avisos cuando hay 2, 1 o 0 repuestos

---

## 🔧 DATOS NECESARIOS

### Opción 1: Gmail (Más Sencillo)
Necesitan crear/usar una cuenta Gmail para el sistema:

```
Email: ________________@gmail.com
Contraseña de Aplicación: ____ ____ ____ ____
```

**Cómo obtener la contraseña de aplicación:**
1. Ingresar a la cuenta Gmail
2. Ir a: https://myaccount.google.com/security
3. Activar "Verificación en 2 pasos" (si no está activa)
4. Buscar "Contraseñas de aplicaciones"
5. Crear una nueva para "Correo" o "Otra aplicación"
6. Copiar los 16 caracteres generados

---

### Opción 2: Email Corporativo RAYPAC/DML
Si tienen servidor de email corporativo:

```
Servidor SMTP: ___________________________
Puerto: _________ (usualmente 587 o 465)
Usuario (email): ___________________________
Contraseña: ___________________________
Requiere TLS/SSL: [ ] SÍ  [ ] NO
```

**Contactar a:** IT de RAYPAC o proveedor de hosting para estos datos

---

## 🚀 PASOS PARA CONFIGURAR EN PRODUCCIÓN

### 1. Acceder a Render.com
- URL: https://dashboard.render.com
- Usuario: (el que usaste para crear el servicio)

### 2. Seleccionar el Servicio
- Buscar: **"software-de-gestion-dml"**
- Click en el servicio

### 3. Ir a Environment Variables
- Menú lateral → **"Environment"**
- Click en **"Add Environment Variable"**

### 4. Agregar las Variables

#### Si usan Gmail:
```
Variable: MAIL_SERVER
Value: smtp.gmail.com

Variable: MAIL_PORT
Value: 587

Variable: MAIL_USE_TLS
Value: True

Variable: MAIL_USERNAME
Value: [EMAIL_GMAIL_AQUÍ]

Variable: MAIL_PASSWORD
Value: [CONTRASEÑA_APP_16_CARACTERES]

Variable: MAIL_DEFAULT_SENDER
Value: Sistema DML <[EMAIL_GMAIL_AQUÍ]>
```

#### Si usan Email Corporativo:
```
Variable: MAIL_SERVER
Value: [SERVIDOR_SMTP]

Variable: MAIL_PORT
Value: [PUERTO]

Variable: MAIL_USE_TLS
Value: True

Variable: MAIL_USERNAME
Value: [EMAIL_CORPORATIVO]

Variable: MAIL_PASSWORD
Value: [CONTRASEÑA]

Variable: MAIL_DEFAULT_SENDER
Value: Sistema DML Service <[EMAIL_CORPORATIVO]>
```

### 5. Guardar y Reiniciar
- Click **"Save Changes"**
- Render reiniciará automáticamente (tarda 2-3 minutos)

---

## ✅ VERIFICAR QUE FUNCIONA

Después de configurar:

1. **Crear un ingreso RAYPAC de prueba**
2. **Crear una ficha DML** para ese ingreso
3. **Generar el ticket**
4. Verificar que llegue el email al comercial configurado

Si no llega:
- Revisar logs en Render → Tab "Logs"
- Buscar mensajes tipo: "✅ Mail enviado" o "⚠️ Error enviando mail"

---

## 📋 NOTAS IMPORTANTES

### Límites de Gmail
- **500 emails por día**
- Para producción: suficiente para operación normal
- Si necesitan más: considerar SendGrid o AWS SES

### Email por Defecto
El sistema usará el email configurado en `MAIL_DEFAULT_SENDER` como remitente.
Los destinatarios son:
- Los emails de comerciales cargados en cada ingreso RAYPAC
- Pueden ser diferentes para cada máquina

### Sin Configuración
- El sistema **funciona perfectamente sin emails**
- Solo imprime en consola/logs que se enviaría
- Todas las demás funciones operan normalmente

---

## 📞 CONTACTO PARA AYUDA

Una vez tengan los datos de email, contactar a:
- **Desarrollador:** [Tu nombre/contacto]
- Proveer los datos de SMTP
- Se configura en 5 minutos

---

## 🔒 SEGURIDAD

- **NUNCA** subir contraseñas al repositorio Git
- Solo configurar en Variables de Entorno de Render
- Usar contraseñas de aplicación (no la principal)
- Gmail: la contraseña normal NO funcionará, debe ser de aplicación

---

**Estado Actual:** ⚠️ EMAILS DESHABILITADOS (falta configuración)  
**Impacto:** Sistema funciona 100%, solo falta notificaciones automáticas  
**Prioridad:** MEDIA (configurar después de validación con David)
