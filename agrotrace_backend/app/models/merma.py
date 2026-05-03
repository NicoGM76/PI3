from datetime import datetime
from sqlalchemy import DateTime, ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class Merma(Base):
    __tablename__ = "merma"

    id_merma: Mapped[int] = mapped_column(primary_key=True)
    id_empaque: Mapped[int] = mapped_column(ForeignKey("empaque.id_empaque"), nullable=False)
    cantidad: Mapped[int] = mapped_column(nullable=False)
    motivo: Mapped[str | None] = mapped_column(String(150))
    fecha_merma: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    id_usuario: Mapped[int] = mapped_column(ForeignKey("usuario.id_usuario"), nullable=False)
