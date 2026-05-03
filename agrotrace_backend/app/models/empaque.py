from datetime import date
from sqlalchemy import Date, ForeignKey, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class Empaque(Base):
    __tablename__ = "empaque"

    id_empaque: Mapped[int] = mapped_column(primary_key=True)
    id_lote: Mapped[int] = mapped_column(ForeignKey("lote.id_lote"), nullable=False)
    fecha_empaque: Mapped[date] = mapped_column(Date, nullable=False)
    peso_total: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    total_unidades: Mapped[int] = mapped_column(nullable=False)
    estado_empaque: Mapped[str] = mapped_column(String(20), default="activo", nullable=False)
    id_usuario: Mapped[int] = mapped_column(ForeignKey("usuario.id_usuario"), nullable=False)
