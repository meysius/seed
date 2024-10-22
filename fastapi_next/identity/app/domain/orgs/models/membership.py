from typing import TYPE_CHECKING
from uuid import UUID, uuid4
from datetime import datetime
from enum import Enum
from app.domain.orm_base import OrmBase
from sqlalchemy import String, Uuid, Enum as SQLAlchemyEnum, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.domain.orgs.models.organization import Organization

if TYPE_CHECKING:
    from app.domain.auth.models.user import User

class Role(Enum):
    OWNER = "OWNER"
    MEMBER = "MEMBER"

class MembershipStatus(Enum):
    INVITED = "INVITED"
    ACTIVE = "ACTIVE"
    INACTIVE = "INACTIVE"

class Membership(OrmBase):
    __tablename__ = "memberships"

    id: Mapped[UUID] = mapped_column(Uuid(as_uuid=True), primary_key=True, default=uuid4)
    role: Mapped[Role] = mapped_column(SQLAlchemyEnum(Role), default=Role.OWNER)
    status: Mapped[MembershipStatus] = mapped_column(SQLAlchemyEnum(MembershipStatus), default=MembershipStatus.ACTIVE)
    invitation_token: Mapped[str | None] = mapped_column(String, unique=True, nullable=True)
    invitation_sent_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    user_id: Mapped[UUID] = mapped_column(Uuid(as_uuid=True), ForeignKey("users.id"))
    organization_id: Mapped[UUID] = mapped_column(Uuid(as_uuid=True), ForeignKey("organizations.id"))

    user: Mapped["User"] = relationship(back_populates="memberships")
    organization: Mapped[Organization] = relationship(back_populates="memberships")