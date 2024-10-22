import logging.config
import uvicorn
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from typing import AsyncGenerator
from fastapi import FastAPI
from app.database import engine
from app.domain.errors import ClientError
from contextlib import asynccontextmanager
from app.config import settings
import logging
from fastapi.exceptions import RequestValidationError

from app.routers.user_router import router as user_router
from app.routers.session_router import router as session_router
from app.routers.pass_reset_router import router as pass_reset_router
from app.routers.membership_router import router as membership_router
from app.routers.organization_router import router as organization_router

def setup_logging() -> None:
    # log_format = "%(asctime)s [%(levelname)s] %(name)s %(message)s"
    log_format = "%(asctime)s [%(levelname)s]\n%(message)s\n\n"
    loggers = {
        "": {
            "level": settings.LOG_LEVEL.value,
            "handlers": ["default"],
            "propagate": False,
        },
        "uvicorn": {
            "level": settings.LOG_LEVEL.value,
            "handlers": ["default"],
        },
        "sqlalchemy.engine": {
            "level": "INFO" if settings.ENABLE_SQL_LOGS else "WARNING",
            "handlers": ["default"],
            "propagate": False,
        },
        "sqlalchemy.pool": {
            "level": "INFO" if settings.ENABLE_SQL_LOGS else "WARNING",
            "handlers": ["default"],
            "propagate": False,
        },
    }
    logging_config = {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "standard": {"format": log_format},
        },
        "handlers": {
            "default": {
                "level": settings.LOG_LEVEL.value,
                "formatter": "standard",
                "class": "logging.StreamHandler",
                "stream": "ext://sys.stdout",  # Default is stderr
            },
        },
        "loggers": loggers,
    }

    logging.config.dictConfig(logging_config)


setup_logging()

@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:  # pragma: no cover
    yield
    await engine.dispose()


app = FastAPI(lifespan=lifespan)
app.include_router(user_router)
app.include_router(session_router)
app.include_router(pass_reset_router)
app.include_router(membership_router)
app.include_router(organization_router)

@app.exception_handler(ClientError)
async def client_error_handler(request: Request, exc: ClientError) -> JSONResponse:
    return JSONResponse(
        status_code=exc.get_status_code(),
        content=exc.get_error_data().model_dump(),
    )

@app.exception_handler(RequestValidationError)
async def resource_not_found_error_handler(request: Request, exc: RequestValidationError) -> JSONResponse:
    return JSONResponse(
        status_code=500,
        content={"id": "InternalServerError"},
    )

def main() -> None:
    uvicorn.run(
        root_path="",
        app="app.main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.RELOAD,
        workers=settings.WORKERS,
    )


if __name__ == "__main__":
    main()
