"""
Swisscierge API - Main application entry point

AI-powered daily routine assistant API built with FastAPI.
Handles authentication, routine generation, calendar sync, and health data integration.
"""

from contextlib import asynccontextmanager
from typing import AsyncGenerator

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from api.core.config import settings
from api.core.scheduler import scheduler

# Import routers (will be implemented later)
# from api.routers import auth, users, calendars, health, routines, export


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator:
    """
    Lifespan context manager for FastAPI app.
    Handles startup and shutdown events.
    """
    # Startup: Initialize scheduler for morning routine generation
    scheduler.start()
    print("✅ APScheduler started - routine generation jobs scheduled")

    yield

    # Shutdown: Clean up resources
    scheduler.shutdown()
    print("🛑 APScheduler stopped")


# Initialize FastAPI app
app = FastAPI(
    title="Swisscierge API",
    description="AI-powered daily routine assistant with Swiss precision",
    version="1.0.0",
    docs_url="/docs" if settings.DEBUG else None,  # Disable docs in production
    redoc_url="/redoc" if settings.DEBUG else None,
    lifespan=lifespan,
)

# CORS middleware - adjust origins for production
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Health check endpoint
@app.get("/health", tags=["Health"])
async def health_check() -> JSONResponse:
    """Health check endpoint for monitoring"""
    return JSONResponse(
        status_code=200,
        content={
            "status": "healthy",
            "environment": settings.ENVIRONMENT,
            "version": "1.0.0",
        },
    )


# Root endpoint
@app.get("/", tags=["Root"])
async def root() -> JSONResponse:
    """API root endpoint"""
    return JSONResponse(
        status_code=200,
        content={
            "message": "Welcome to Swisscierge API",
            "version": "1.0.0",
            "docs": "/docs" if settings.DEBUG else "disabled",
        },
    )


# Register routers (will be implemented later)
# app.include_router(auth.router, prefix="/v1/auth", tags=["Authentication"])
# app.include_router(users.router, prefix="/v1/users", tags=["Users"])
# app.include_router(calendars.router, prefix="/v1/calendars", tags=["Calendars"])
# app.include_router(health.router, prefix="/v1/health", tags=["Health"])
# app.include_router(routines.router, prefix="/v1/routines", tags=["Routines"])
# app.include_router(export.router, prefix="/v1/export", tags=["Export"])


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "api.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.DEBUG,
        log_level="debug" if settings.DEBUG else "info",
    )
