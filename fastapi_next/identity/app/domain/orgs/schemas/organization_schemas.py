from pydantic import BaseModel, UUID4

class OrganizationSchema(BaseModel):
    id: UUID4
    name: str

    class Config:
        from_attributes = True

class CreateOrganizationRequest(BaseModel):
    name: str

class CreateOrganizationResponse(BaseModel):
    organization: OrganizationSchema