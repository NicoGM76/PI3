from datetime import datetime
from sqlalchemy import DateTime, ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class MovimientoInventario(Base):
    __tablename__ = "movimiento_inventario"

    id_movimiento: Mapped[int] = mapped_column(primary_key=True)
    id_paquete: Mapped[int] = mapped_column(ForeignKey("paquete.id_paquete"), nullable=False)
    tipo_movimiento: Mapped[str] = mapped_column(String(20), nullable=False)
    cantidad: Mapped[int] = mapped_column(nullable=False)
    motivo: Mapped[str | None] = mapped_column(String(150))
    fecha_movimiento: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    id_usuario: Mapped[int] = mapped_column(ForeignKey("usuario.id_usuario"), nullable=False)
