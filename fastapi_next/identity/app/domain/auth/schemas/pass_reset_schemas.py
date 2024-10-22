from pydantic import BaseModel, EmailStr
from datetime import datetime

class CreatePassResetRequest(BaseModel):
    email: EmailStr

class CreatePassResetResponse(BaseModel):
    success: bool

class GetPassResetResponse(BaseModel):
    pass_reset_token: str
    pass_reset_token_created_at: str

class UpdatePassResetRequest(BaseModel):
    password: str

class UpdatePassResetResponse(BaseModel):
    success: bool