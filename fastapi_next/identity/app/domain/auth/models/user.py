from uuid import UUID, uuid4
from datetime import datetime
from enum import Enum
from app.domain.orm_base import OrmBase
from sqlalchemy import String, Uuid, Boolean, DateTime, Enum as SQLAlchemyEnum, LargeBinary
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.domain.orgs.models.membership import Membership

class Source(Enum):
    SELF_SIGNUP = "SELF_SIGNUP"
    INVITATION = "INVITATION"

class User(OrmBase):
    __tablename__ = "users"

    id: Mapped[UUID] = mapped_column(Uuid(as_uuid=True), primary_key=True, default=uuid4)
    source: Mapped[Source] = mapped_column(SQLAlchemyEnum(Source), default=Source.SELF_SIGNUP, nullable=False)
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    hashed_password: Mapped[bytes | None] = mapped_column(LargeBinary())
    first_name: Mapped[str | None] = mapped_column(String(255))
    last_name: Mapped[str | None] = mapped_column(String(255))
    onboarded: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    email_confirmation_token: Mapped[UUID | None] = mapped_column(Uuid(as_uuid=True), unique=True)
    email_confirmation_token_sent_at: Mapped[datetime | None] = mapped_column(DateTime)
    email_confirmed: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    pass_reset_token: Mapped[UUID | None] = mapped_column(Uuid(as_uuid=True), unique=True)
    pass_reset_token_created_at: Mapped[datetime | None] = mapped_column(DateTime)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    memberships: Mapped[list[Membership]] = relationship(back_populates="user")
