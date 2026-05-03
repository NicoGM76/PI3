from datetime import date
from pydantic import BaseModel


class PaqueteCreate(BaseModel):
    id_empaque: int
    numero_paquete: int
    peso_neto: float
    fecha_vencimiento: date | None = None
    estado: str = "disponible"
    id_bodega: int


class PaqueteResponse(BaseModel):
    id_paquete: int
    id_empaque: int
    numero_paquete: int
    peso_neto: float
    fecha_vencimiento: date | None = None
    estado: str
    id_bodega: int

    class Config:
        from_attributes = True
