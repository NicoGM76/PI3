from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.models.lote import Lote
from app.schemas.lote import LoteCreate, LoteResponse
from app.routers.deps import get_current_user

router = APIRouter(prefix="/lotes", tags=["lotes"])


@router.post("/", response_model=LoteResponse, status_code=status.HTTP_201_CREATED)
def create_lote(
    payload: LoteCreate,
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    existing = db.query(Lote).filter(Lote.codigo_lote == payload.codigo_lote).first()
    if existing:
        raise HTTPException(status_code=400, detail="El código de lote ya existe")

    lote = Lote(**payload.model_dump())
    db.add(lote)
    db.commit()
    db.refresh(lote)
    return lote


@router.get("/", response_model=list[LoteResponse])
def list_lotes(
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    return db.query(Lote).order_by(Lote.id_lote).all()


@router.get("/{lote_id}", response_model=LoteResponse)
def get_lote(
    lote_id: int,
    db: Session = Depends(get_db),
    _current_user=Depends(get_current_user),
):
    lote = db.get(Lote, lote_id)
    if not lote:
        raise HTTPException(status_code=404, detail="Lote no encontrado")
    return lote
