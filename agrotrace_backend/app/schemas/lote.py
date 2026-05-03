from datetime import date
from pydantic import BaseModel


class LoteCreate(BaseModel):
    codigo_lote: str
    fecha_siembra: date | None = None
    fecha_cosecha: date | None = None
    estado: str = "activo"
    id_variedad: int
    id_ubicacion: int
    id_usuario_creador: int


class LoteResponse(BaseModel):
    id_lote: int
    codigo_lote: str
    fecha_siembra: date | None = None
    fecha_cosecha: date | None = None
    estado: str
    id_variedad: int
    id_ubicacion: int
    id_usuario_creador: int

    class Config:
        from_attributes = True
