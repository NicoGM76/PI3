from datetime import date
from pydantic import BaseModel


class EmpaqueCreate(BaseModel):
    id_lote: int
    fecha_empaque: date
    peso_total: float
    total_unidades: int
    estado_empaque: str = "activo"
    id_usuario: int


class EmpaqueResponse(BaseModel):
    id_empaque: int
    id_lote: int
    fecha_empaque: date
    peso_total: float
    total_unidades: int
    estado_empaque: str
    id_usuario: int

    class Config:
        from_attributes = True
