from pydantic import BaseModel, EmailStr, Field, RootModel
from typing import Literal, Union
from app.domain.auth.schemas.user_schemas import UserSchema

class CredentialsRequest(BaseModel):
    provider: Literal['credentials']
    email: EmailStr
    password: str

class TokenRequest(BaseModel):
    provider: Literal['google', 'invitation', 'email_confirmation']
    token: str

CreateSessionRequest = TokenRequest | CredentialsRequest

class CreateSessionResponse(BaseModel):
    user: UserSchema
    access_token: str

class GetSessionResponse(BaseModel):
    user: UserSchema