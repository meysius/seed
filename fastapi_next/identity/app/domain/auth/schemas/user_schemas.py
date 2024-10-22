from pydantic import BaseModel, EmailStr, UUID4

class UserSchema(BaseModel):
    id: UUID4
    email: EmailStr
    first_name: str | None
    last_name: str | None
    onboarded: bool
    source: str

    class Config:
        from_attributes = True

class CreateUserRequest(BaseModel):
    email: EmailStr
    password: str

class CreateUserResponse(BaseModel):
    user: UserSchema

class UpdateUserRequest(BaseModel):
    first_name: str
    last_name: str

class UpdateUserResponse(BaseModel):
    user: UserSchema
