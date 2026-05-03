from datetime import datetime
from sqlalchemy import DateTime, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class LogSistema(Base):
    __tablename__ = "log_sistema"

    id_log: Mapped[int] = mapped_column(primary_key=True)
    id_usuario: Mapped[int | None] = mapped_column(ForeignKey("usuario.id_usuario"))
    accion: Mapped[str] = mapped_column(String(100), nullable=False)
    modulo: Mapped[str] = mapped_column(String(100), nullable=False)
    fecha_hora: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    descripcion: Mapped[str | None] = mapped_column(Text)
