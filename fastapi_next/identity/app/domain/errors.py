from abc import ABC, abstractmethod
from pydantic import BaseModel
from sqlalchemy.exc import IntegrityError

class ErrorData(BaseModel):
    id: str
    params: dict[str, int | bool | str]

class ClientError(ABC, Exception):
    def __init__(self, message: str):
        super().__init__(message)

    @abstractmethod
    def get_status_code(self) -> int:
        pass

    @abstractmethod
    def get_error_params(self) -> dict[str, int | bool | str]:
        pass

    def get_error_data(self) -> ErrorData:
        return ErrorData(
            id=self.__class__.__name__,
            params=self.get_error_params(),
        )

class AuthenticationFailedError(ClientError):
    def __init__(self, message: str):
        super().__init__(message)
        self.message = message

    def get_status_code(self) -> int:
        return 401

    def get_error_params(self) -> dict[str, int | bool | str]:
        return {"message": self.message}


class ValidationError(ClientError):
    def __init__(self, errors: dict[str, str | int | bool]):
        super().__init__("Validation Error")
        self.errors = errors

    def get_status_code(self) -> int:
        return 422

    def get_error_params(self) -> dict[str, str | int | bool]:
        return self.errors

class ResourceNotFoundError(ClientError):
    resource: str

    def __init__(self, resource: str):
        super().__init__(f"{resource} not found")
        self.resource = resource

    def get_status_code(self) -> int:
        return 404

    def get_error_params(self) -> dict[str, str | int | bool]:
        return {"resource_name": self.resource}


def get_constraint_name(e: IntegrityError) -> str:
    orig = e.orig
    assert orig
    return orig.__cause__.__dict__["constraint_name"]