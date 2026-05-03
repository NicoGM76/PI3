from datetime import datetime
from sqlalchemy import DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class Transferencia(Base):
    __tablename__ = "transferencia"

    id_transferencia: Mapped[int] = mapped_column(primary_key=True)
    id_paquete: Mapped[int] = mapped_column(ForeignKey("paquete.id_paquete"), nullable=False)
    id_bodega_origen: Mapped[int] = mapped_column(ForeignKey("bodega.id_bodega"), nullable=False)
    id_bodega_destino: Mapped[int] = mapped_column(ForeignKey("bodega.id_bodega"), nullable=False)
    cantidad: Mapped[int] = mapped_column(nullable=False)
    fecha_transferencia: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    id_usuario: Mapped[int] = mapped_column(ForeignKey("usuario.id_usuario"), nullable=False)
