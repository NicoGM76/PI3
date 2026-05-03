from sqlalchemy import String, Text
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class Insumo(Base):
    __tablename__ = "insumo"

    id_insumo: Mapped[int] = mapped_column(primary_key=True)
    nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    tipo: Mapped[str] = mapped_column(String(80), nullable=False)
    unidad_medida: Mapped[str] = mapped_column(String(30), nullable=False)
    descripcion: Mapped[str | None] = mapped_column(Text)
