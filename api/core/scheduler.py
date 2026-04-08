"""
APScheduler configuration for scheduled jobs

Handles:
- Morning routine generation (5:00 AM user local time)
- 90-day routine cleanup (2:00 AM UTC)
- Weather forecast updates (every 3 hours)
- Calendar sync (hourly)
"""

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger

# Initialize scheduler
scheduler = AsyncIOScheduler()


def schedule_morning_routine_generation() -> None:
    """
    Schedule morning routine generation for all users at 5:00 AM in their timezone.
    This will be triggered by the scheduler service.
    """
    # TODO: Implement in api/services/scheduler_service.py
    # This function will:
    # 1. Query all active users
    # 2. For each user, check their timezone
    # 3. Generate routine if it's 5:00 AM in their local time
    pass


def schedule_cleanup_expired_routines() -> None:
    """
    Schedule 90-day routine cleanup at 2:00 AM UTC daily.
    Deletes routines older than 90 days per data retention policy.
    """
    # TODO: Implement in api/services/scheduler_service.py
    pass


def schedule_weather_forecast_updates() -> None:
    """
    Schedule weather forecast updates every 3 hours.
    Fetches hourly forecasts for next 24 hours for all active users.
    """
    # TODO: Implement in api/services/scheduler_service.py
    pass


def schedule_calendar_sync() -> None:
    """
    Schedule calendar sync every hour for all users with active connections.
    """
    # TODO: Implement in api/services/scheduler_service.py
    pass


# Register jobs
def register_scheduled_jobs() -> None:
    """Register all scheduled jobs with APScheduler"""

    # Morning routine generation - runs every hour to check timezone-specific 5am
    scheduler.add_job(
        schedule_morning_routine_generation,
        CronTrigger(minute=0),  # Every hour at :00
        id="morning_routine_generation",
        name="Generate morning routines for users at 5:00 AM local time",
        replace_existing=True,
    )

    # Cleanup expired routines - runs daily at 2:00 AM UTC
    scheduler.add_job(
        schedule_cleanup_expired_routines,
        CronTrigger(hour=2, minute=0),  # Daily at 2:00 AM UTC
        id="cleanup_expired_routines",
        name="Delete routines older than 90 days",
        replace_existing=True,
    )

    # Weather forecast updates - runs every 3 hours
    scheduler.add_job(
        schedule_weather_forecast_updates,
        CronTrigger(hour="*/3"),  # Every 3 hours
        id="weather_forecast_updates",
        name="Update weather forecasts for all users",
        replace_existing=True,
    )

    # Calendar sync - runs every hour
    scheduler.add_job(
        schedule_calendar_sync,
        CronTrigger(minute=30),  # Every hour at :30
        id="calendar_sync",
        name="Sync calendar events for all users",
        replace_existing=True,
    )


# Register jobs when scheduler starts
register_scheduled_jobs()
