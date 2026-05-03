from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.models.aplicacion_insumo import AplicacionInsumo
from app.schemas.aplicacion_insumo import AplicacionInsumoCreate, AplicacionInsumoResponse
from app.routers.deps import get_current_user

router = APIRouter(prefix="/aplicaciones-insumo", tags=["aplicaciones_insumo"])


@router.post("/", response_model=AplicacionInsumoResponse, status_code=status.HTTP_201_CREATED)
def create_aplicacion_insumo(
    payload: AplicacionInsumoCreate,
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    item = AplicacionInsumo(**payload.model_dump())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item


@router.get("/lote/{lote_id}", response_model=list[AplicacionInsumoResponse])
def list_by_lote(
    lote_id: int,
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    return (
        db.query(AplicacionInsumo)
        .filter(AplicacionInsumo.id_lote == lote_id)
        .order_by(AplicacionInsumo.id_aplicacion)
        .all()
    )
