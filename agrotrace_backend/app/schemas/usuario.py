from datetime import datetime
from pydantic import BaseModel, EmailStr


class UsuarioResponse(BaseModel):
    id_usuario: int
    nombre: str
    correo: EmailStr
    estado: str
    fecha_creacion: datetime
    id_rol: int

    class Config:
        from_attributes = True
