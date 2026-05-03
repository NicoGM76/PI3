# AgroTrace Backend

Backend base en **FastAPI + PostgreSQL** para AgroTrace.

## 1. Crear carpeta del proyecto en Visual Studio Code
Abre VS Code y luego abre esta carpeta completa: `agrotrace_backend`.

## 2. Crear entorno virtual
En la terminal de VS Code:

### Windows
```bash
python -m venv .venv
.venv\Scripts\activate
```

### Linux / macOS
```bash
python3 -m venv .venv
source .venv/bin/activate
```

## 3. Instalar dependencias
```bash
pip install -r requirements.txt
```

## 4. Configurar variables de entorno
Copia `.env.example` a `.env` y reemplaza:
- `DATABASE_URL`
- `JWT_SECRET_KEY`

Ejemplo:
```env
DATABASE_URL=postgresql+psycopg://postgres:TU_PASSWORD@TU_HOST:5432/postgres
JWT_SECRET_KEY=una_clave_larga_y_privada
```

## 5. Crear la base del backend
El backend usa el esquema ya creado en PostgreSQL.  
No hace migraciones automáticas. Debes tener ya ejecutado el SQL de AgroTrace en la base a la que apuntes.

## 6. Ejecutar
```bash
uvicorn app.main:app --reload
```

## 7. Probar
Abre en el navegador:
- Swagger UI: `http://127.0.0.1:8000/docs`
- OpenAPI JSON: `http://127.0.0.1:8000/openapi.json`

## 8. Primer flujo recomendado
1. `POST /auth/register`
2. `POST /auth/login`
3. Copiar el token
4. Clic en **Authorize** en Swagger
5. Probar `GET /auth/me`
6. Crear y consultar lotes

## 9. Estructura
- `app/main.py` arranque principal
- `app/core/` configuración, DB y seguridad
- `app/models/` modelos SQLAlchemy
- `app/schemas/` modelos Pydantic
- `app/routers/` endpoints

## 10. Nota importante
Si tu base en RDS vuelve a dar problemas de red, primero prueba con pgAdmin.  
Si pgAdmin conecta, el backend también debería poder conectar usando la misma URL, usuario y contraseña.
