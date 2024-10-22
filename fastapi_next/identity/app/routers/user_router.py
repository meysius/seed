from fastapi import APIRouter
from app.domain.auth.schemas.user_schemas import (
    CreateUserRequest,
    CreateUserResponse,
    UserSchema,
    UpdateUserRequest,
    UpdateUserResponse
)
from app.dependencies import CurrentUserId, AuthServiceDep

router = APIRouter()

@router.post("/api/users")
async def create_user(request: CreateUserRequest, auth_service: AuthServiceDep) -> CreateUserResponse:
    user = await auth_service.create_user(request.email, request.password)
    user_data = UserSchema.model_validate(user)
    create_user_response = CreateUserResponse(user=user_data)
    return create_user_response

@router.put("/api/user")
async def update_user(
    request: UpdateUserRequest,
    auth_service: AuthServiceDep,
    current_user_id: CurrentUserId
) -> UpdateUserResponse:
    new_user = await auth_service.onboard_user(
        user_id=current_user_id,
        first_name=request.first_name,
        last_name=request.last_name
    )
    return UpdateUserResponse(user=UserSchema.model_validate(new_user))