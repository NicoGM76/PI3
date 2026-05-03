from datetime import datetime
from pydantic import BaseModel


class AplicacionInsumoCreate(BaseModel):
    id_lote: int
    id_insumo: int
    cantidad: float
    id_usuario: int


class AplicacionInsumoResponse(BaseModel):
    id_aplicacion: int
    id_lote: int
    id_insumo: int
    cantidad: float
    fecha_aplicacion: datetime
    id_usuario: int

    class Config:
        from_attributes = True
