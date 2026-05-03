from datetime import datetime
from sqlalchemy import DateTime, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class CodigoQR(Base):
    __tablename__ = "codigo_qr"

    id_qr: Mapped[int] = mapped_column(primary_key=True)
    id_paquete: Mapped[int] = mapped_column(ForeignKey("paquete.id_paquete"), unique=True, nullable=False)
    codigo_qr: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    datos_serializados: Mapped[str | None] = mapped_column(Text)
    fecha_generacion: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
