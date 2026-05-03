from sqlalchemy import String, Text
from sqlalchemy.orm import Mapped, mapped_column
from app.core.db import Base


class Variedad(Base):
    __tablename__ = "variedad"

    id_variedad: Mapped[int] = mapped_column(primary_key=True)
    nombre: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    categoria: Mapped[str | None] = mapped_column(String(80))
    descripcion: Mapped[str | None] = mapped_column(Text)
