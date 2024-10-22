from fastapi import APIRouter
from app.domain.auth.schemas.user_schemas import UserSchema
from app.domain.auth.schemas.session_schemas import CreateSessionRequest, CreateSessionResponse, GetSessionResponse
from app.dependencies import CurrentUserId, AuthServiceDep
import logging

logger = logging.getLogger(__name__)

router = APIRouter()

@router.post("/api/sessions")
async def create_session(request: CreateSessionRequest, auth_service: AuthServiceDep) -> CreateSessionResponse:
    if request.provider == 'credentials':
        user = await auth_service.authenticate_with_creds(request.email, request.password)
    elif request.provider == 'google':
        user = await auth_service.authenticate_with_google(request.token)
    elif request.provider == 'invitation':
        user = await auth_service.authenticate_with_invitation(request.token)
    elif request.provider == 'email_confirmation':
        user = await auth_service.authenticate_with_email_confirmation(request.token)
    else:
        raise ValueError('Invalid provider')

    access_token = await auth_service.create_access_token(str(user.id))
    return CreateSessionResponse(
        user=UserSchema.model_validate(user),
        access_token=access_token
    )


@router.get("/api/session")
async def get_session(auth_service: AuthServiceDep, current_user_id: CurrentUserId) -> GetSessionResponse:
    user = await auth_service.find_user_by_id(current_user_id)
    return GetSessionResponse(user=UserSchema.model_validate(user))