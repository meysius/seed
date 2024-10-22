from typing import TYPE_CHECKING
from uuid import UUID, uuid4
from datetime import datetime
from app.domain.orm_base import OrmBase
from sqlalchemy import String, Uuid, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from app.domain.orgs.models.membership import Membership

class Organization(OrmBase):
    __tablename__ = "organizations"

    id: Mapped[UUID] = mapped_column(Uuid(as_uuid=True), primary_key=True, default=uuid4)
    name: Mapped[str] = mapped_column(String(255), unique=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    memberships: Mapped[list["Membership"]] = relationship(back_populates="organization")