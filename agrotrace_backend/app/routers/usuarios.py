from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.models.usuario import Usuario
from app.schemas.usuario import UsuarioResponse
from app.routers.deps import get_current_user

router = APIRouter(prefix="/usuarios", tags=["usuarios"])


@router.get("/", response_model=list[UsuarioResponse])
def list_usuarios(
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    return db.query(Usuario).order_by(Usuario.id_usuario).all()


@router.get("/{usuario_id}", response_model=UsuarioResponse)
def get_usuario(
    usuario_id: int,
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    return db.get(Usuario, usuario_id)
