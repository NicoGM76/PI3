from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.core.security import create_access_token, hash_password, verify_password
from app.models.usuario import Usuario
from app.schemas.auth import LoginRequest, RegisterRequest, TokenResponse
from app.schemas.usuario import UsuarioResponse
from app.routers.deps import get_current_user

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register", response_model=UsuarioResponse, status_code=status.HTTP_201_CREATED)
def register(payload: RegisterRequest, db: Session = Depends(get_db)):
    existing = db.query(Usuario).filter(Usuario.correo == payload.correo).first()
    if existing:
        raise HTTPException(status_code=400, detail="El correo ya está registrado")

    user = Usuario(
        nombre=payload.nombre,
        correo=payload.correo,
        contrasena_hash=hash_password(payload.password),
        estado="activo",
        id_rol=payload.id_rol,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@router.post("/login", response_model=TokenResponse)
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(Usuario).filter(Usuario.correo == payload.correo).first()
    if not user or not verify_password(payload.password, user.contrasena_hash):
        raise HTTPException(status_code=401, detail="Credenciales inválidas")

    token = create_access_token(str(user.id_usuario))
    return TokenResponse(access_token=token)


@router.get("/me", response_model=UsuarioResponse)
def me(current_user: Usuario = Depends(get_current_user)):
    return current_user
