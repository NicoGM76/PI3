from sqlalchemy import String, Text
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class Bodega(Base):
    __tablename__ = "bodega"

    id_bodega: Mapped[int] = mapped_column(primary_key=True)
    nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    ubicacion: Mapped[str | None] = mapped_column(String(120))
    descripcion: Mapped[str | None] = mapped_column(Text)
