from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text

from app.core.config import settings
from app.core.db import SessionLocal
from app.routers.auth import router as auth_router
from app.routers.usuarios import router as usuarios_router
from app.routers.lotes import router as lotes_router
from app.routers.aplicaciones_insumo import router as aplicaciones_insumo_router
from app.routers.empaques import router as empaques_router
from app.routers.paquetes import router as paquetes_router

app = FastAPI(title=settings.app_name, version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {
        "message": "AgroTrace Backend funcionando",
        "docs": "/docs",
        "version": "0.1.0",
    }


@app.get("/health")
def health():
    db = SessionLocal()
    try:
        db.execute(text("SELECT 1"))
        return {"status": "ok", "database": "connected"}
    finally:
        db.close()


app.include_router(auth_router)
app.include_router(usuarios_router)
app.include_router(lotes_router)
app.include_router(aplicaciones_insumo_router)
app.include_router(empaques_router)
app.include_router(paquetes_router)
