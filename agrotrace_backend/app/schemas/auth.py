from pydantic import BaseModel, EmailStr


class RegisterRequest(BaseModel):
    nombre: str
    correo: EmailStr
    password: str
    id_rol: int


class LoginRequest(BaseModel):
    correo: EmailStr
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
