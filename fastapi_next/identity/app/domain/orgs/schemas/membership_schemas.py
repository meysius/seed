from pydantic import BaseModel, UUID4
from enum import Enum
from app.domain.orgs.schemas.organization_schemas import OrganizationSchema

class Role(str, Enum):
    OWNER = "OWNER"
    MEMBER = "MEMBER"

class MembershipSchema(BaseModel):
    id: UUID4
    role: Role
    organization_id: UUID4
    user_id: UUID4

    class Config:
        from_attributes = True

class MembershipWithOrganizationSchema(MembershipSchema):
    organization: OrganizationSchema

class ListUserMembershipsResponse(BaseModel):
    memberships: list[MembershipWithOrganizationSchema]
