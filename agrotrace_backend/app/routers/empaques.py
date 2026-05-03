from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.models.empaque import Empaque
from app.schemas.empaque import EmpaqueCreate, EmpaqueResponse
from app.routers.deps import get_current_user

router = APIRouter(prefix="/empaques", tags=["empaques"])


@router.post("/", response_model=EmpaqueResponse, status_code=status.HTTP_201_CREATED)
def create_empaque(
    payload: EmpaqueCreate,
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    item = Empaque(**payload.model_dump())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item


@router.get("/", response_model=list[EmpaqueResponse])
def list_empaques(
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    return db.query(Empaque).order_by(Empaque.id_empaque).all()
