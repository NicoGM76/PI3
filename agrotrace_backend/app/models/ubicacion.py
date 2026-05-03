from sqlalchemy import String, Text
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class Ubicacion(Base):
    __tablename__ = "ubicacion"

    id_ubicacion: Mapped[int] = mapped_column(primary_key=True)
    nombre_finca: Mapped[str] = mapped_column(String(120), nullable=False)
    parcela: Mapped[str | None] = mapped_column(String(80))
    codigo_interno: Mapped[str | None] = mapped_column(String(50), unique=True)
    descripcion: Mapped[str | None] = mapped_column(Text)
