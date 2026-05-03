from datetime import date
from sqlalchemy import Date, ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.core.db import Base


class Lote(Base):
    __tablename__ = "lote"

    id_lote: Mapped[int] = mapped_column(primary_key=True)
    codigo_lote: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    fecha_siembra: Mapped[date | None] = mapped_column(Date)
    fecha_cosecha: Mapped[date | None] = mapped_column(Date)
    estado: Mapped[str] = mapped_column(String(30), default="activo", nullable=False)
    id_variedad: Mapped[int] = mapped_column(ForeignKey("variedad.id_variedad"), nullable=False)
    id_ubicacion: Mapped[int] = mapped_column(ForeignKey("ubicacion.id_ubicacion"), nullable=False)
    id_usuario_creador: Mapped[int] = mapped_column(ForeignKey("usuario.id_usuario"), nullable=False)

    usuario_creador = relationship("Usuario", back_populates="lotes_creados")
