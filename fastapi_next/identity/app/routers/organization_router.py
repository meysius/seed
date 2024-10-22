from fastapi import APIRouter
from app.domain.orgs.orgs_service import OrgsServiceDep
from app.dependencies import CurrentUserId
from app.domain.orgs.schemas.organization_schemas import (
    OrganizationSchema,
    CreateOrganizationRequest,
    CreateOrganizationResponse
)
import logging

router = APIRouter()

@router.post("/api/organizations")
async def create_organization(
    current_user_id: CurrentUserId,
    request: CreateOrganizationRequest,
    orgs_service: OrgsServiceDep
) -> CreateOrganizationResponse:
    org = await orgs_service.create_organization(current_user_id, request.name)
    logging.info(org)
    return CreateOrganizationResponse(
        organization=OrganizationSchema.model_validate(org)
    )
