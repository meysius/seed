from typing import Annotated
from fastapi import Depends
from app.domain.orgs.models.membership import Membership, Role, MembershipStatus
from app.domain.orgs.models.organization import Organization
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from app.database import get_db_session
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from app.domain.errors import ValidationError, get_constraint_name

class OrgsService:
    def __init__(self, session: AsyncSession = Depends(get_db_session)):
        self.session = session

    async def list_user_memberships(self, user_id: str) -> list[Membership]:
        print("HEY!!!!!!!!!")
        memberships = await self.session.scalars(
            select(Membership)
            .options(selectinload(Membership.organization))
            .where(Membership.user_id == user_id)
        )
        return list(memberships.all())

    async def create_organization(self, user_id: str, name: str) -> Organization:
        org = Organization(
            name=name,
            memberships=[
                Membership(
                    role=Role.OWNER,
                    status=MembershipStatus.ACTIVE,
                    user_id=user_id
                )
            ]
        )
        try:
            async with self.session.begin_nested():
                self.session.add(org)
        except IntegrityError as e:
            if get_constraint_name(e) == "organizations_name_key":
                raise ValidationError({ "name": "This name is already taken" })
        return org

OrgsServiceDep = Annotated[OrgsService, Depends(OrgsService)]