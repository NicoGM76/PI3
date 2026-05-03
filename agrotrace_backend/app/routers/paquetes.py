from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.models.paquete import Paquete
from app.schemas.paquete import PaqueteCreate, PaqueteResponse
from app.routers.deps import get_current_user

router = APIRouter(prefix="/paquetes", tags=["paquetes"])


@router.post("/", response_model=PaqueteResponse, status_code=status.HTTP_201_CREATED)
def create_paquete(
    payload: PaqueteCreate,
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    item = Paquete(**payload.model_dump())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item


@router.get("/", response_model=list[PaqueteResponse])
def list_paquetes(
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    return db.query(Paquete).order_by(Paquete.id_paquete).all()
