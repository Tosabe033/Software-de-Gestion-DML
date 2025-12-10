# Configuracion del Sistema

Esta carpeta contiene archivos de configuración del sistema DML.

## Contenido

- **.env.example** - Archivo de ejemplo con variables de entorno
- **.env** - Archivo actual de configuración (gitignored en producción)

## Variables de Configuracion

```
FLASK_ENV=development
SECRET_KEY=tu-clave-secreta-aqui
DATABASE_URL=sqlite:///dml.db
DEBUG=False
```

## Como Configurar

1. Copia `.env.example` a `.env`
2. Edita `.env` con tus valores específicos
3. Reinicia el servidor para aplicar cambios

**Nota:** El archivo `.env` NO debe compartirse en repositorio público. Usa `.env.example` como plantilla.

**Fecha de actualizacion:** 8 de Diciembre de 2025
