from fastapi import APIRouter
from app.domain.orgs.orgs_service import OrgsServiceDep
from app.dependencies import CurrentUserId
from app.domain.orgs.schemas.membership_schemas import ListUserMembershipsResponse, MembershipWithOrganizationSchema
import logging
router = APIRouter()

@router.get("/api/memberships")
async def get_memberships(current_user_id: CurrentUserId, orgs_service: OrgsServiceDep) -> ListUserMembershipsResponse:
    memberships = await orgs_service.list_user_memberships(current_user_id)
    return ListUserMembershipsResponse(
        memberships=[
            MembershipWithOrganizationSchema.model_validate(membership)
            for membership in memberships
        ]
    )
