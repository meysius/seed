from fastapi import APIRouter, Path
from typing import Annotated
from app.domain.auth.models.user import User
from app.domain.auth.schemas.pass_reset_schemas import (
    CreatePassResetRequest,
    CreatePassResetResponse,
    GetPassResetResponse,
    UpdatePassResetRequest,
    UpdatePassResetResponse
)
from app.dependencies import AuthServiceDep
import logging

logger = logging.getLogger(__name__)

router = APIRouter()

@router.post("/api/pass-resets")
async def create_pass_reset(request: CreatePassResetRequest, auth_service: AuthServiceDep) -> CreatePassResetResponse:
    result = await auth_service.create_password_reset(email=request.email)
    return CreatePassResetResponse(success=result)


@router.get("/api/pass-resets/{pass_reset_token}")
async def get_pass_reset(
    pass_reset_token: Annotated[str, Path()],
    auth_service: AuthServiceDep
) -> GetPassResetResponse:
    user = await auth_service.get_password_reset(pass_reset_token)
    assert user.pass_reset_token_created_at
    return GetPassResetResponse(
        pass_reset_token=pass_reset_token,
        pass_reset_token_created_at=user.pass_reset_token_created_at.isoformat(timespec='milliseconds') + 'Z'
    )

@router.put("/api/pass-resets/{pass_reset_token}")
async def update_pass_reset(
    pass_reset_token: Annotated[str, Path()],
    request: UpdatePassResetRequest,
    auth_service: AuthServiceDep
) -> UpdatePassResetResponse:
    result = await auth_service.update_password_reset(
        pass_reset_token=pass_reset_token,
        new_password=request.password
    )
    return UpdatePassResetResponse(success=result)
