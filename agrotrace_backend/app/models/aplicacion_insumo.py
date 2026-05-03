from datetime import datetime
from sqlalchemy import DateTime, ForeignKey, Numeric
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class AplicacionInsumo(Base):
    __tablename__ = "aplicacion_insumo"

    id_aplicacion: Mapped[int] = mapped_column(primary_key=True)
    id_lote: Mapped[int] = mapped_column(ForeignKey("lote.id_lote"), nullable=False)
    id_insumo: Mapped[int] = mapped_column(ForeignKey("insumo.id_insumo"), nullable=False)
    cantidad: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    fecha_aplicacion: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    id_usuario: Mapped[int] = mapped_column(ForeignKey("usuario.id_usuario"), nullable=False)
