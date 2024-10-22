from fastapi import Header, Depends
from typing import Annotated
from app.domain.auth.auth_service import AuthServiceDep

async def get_current_user_id(auth_service: AuthServiceDep, authorization: str = Header()) -> str:
    access_token = authorization.split(" ")[1]
    return await auth_service.verify_access_token(access_token)
CurrentUserId = Annotated[str, Depends(get_current_user_id)]
