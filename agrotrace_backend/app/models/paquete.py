from datetime import date
from sqlalchemy import Date, ForeignKey, Numeric, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class Paquete(Base):
    __tablename__ = "paquete"
    __table_args__ = (UniqueConstraint("id_empaque", "numero_paquete", name="uq_paquete_empaque_numero"),)

    id_paquete: Mapped[int] = mapped_column(primary_key=True)
    id_empaque: Mapped[int] = mapped_column(ForeignKey("empaque.id_empaque"), nullable=False)
    numero_paquete: Mapped[int] = mapped_column(nullable=False)
    peso_neto: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    fecha_vencimiento: Mapped[date | None] = mapped_column(Date)
    estado: Mapped[str] = mapped_column(String(20), default="disponible", nullable=False)
    id_bodega: Mapped[int] = mapped_column(ForeignKey("bodega.id_bodega"), nullable=False)
