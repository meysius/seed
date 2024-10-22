from fastapi import Depends
from typing import Annotated
from app.domain.auth.models.user import User
from app.domain.orgs.models.membership import Membership
from sqlalchemy import select
from uuid import uuid4
from datetime import datetime, timedelta
from app.domain.errors import AuthenticationFailedError, ValidationError, ResourceNotFoundError
from bcrypt import checkpw, hashpw, gensalt
from google.oauth2 import id_token
from google.auth.transport.requests import Request
from app.config import settings
from jwt import decode, encode
from app.database import get_db_session
from sqlalchemy.ext.asyncio import AsyncSession
import logging

class AuthService:
    def __init__(self, session: AsyncSession = Depends(get_db_session)):
        self.session = session

    async def create_user(self, email: str, password: str) -> User:
        email = email.lower()
        hashed_password = hashpw(password.encode('utf-8'), gensalt())
        user = await self.session.scalar(select(User).where(User.email == email))
        if user and user.email_confirmed:
            raise ValidationError({"email": "Email already in use"})

        five_minutes_ago = datetime.now() - timedelta(minutes=5)

        should_resend_email = (
            user and
            not user.email_confirmed and
            user.email_confirmation_token_sent_at is not None and
            user.email_confirmation_token_sent_at < five_minutes_ago
        )

        send_email = False
        if user and should_resend_email:
            send_email = True
            async with self.session.begin_nested():
                user.email_confirmation_token = uuid4()
                user.email_confirmation_token_sent_at = datetime.now()

        if not user:
            send_email = True
            user = User(
                email=email,
                hashed_password=hashed_password,
                source="SELF_SIGNUP",
                email_confirmed=False,
                email_confirmation_token=uuid4(),
                email_confirmation_token_sent_at=datetime.now()
            )
            async with self.session.begin_nested():
                self.session.add(user)

        if send_email:
            logging.info(f">>>>>>>>>>> SEND EMAIL: {self.get_confirmation_link(user)} to {email}")

        return user

    async def onboard_user(self, user_id: str, first_name: str, last_name: str) -> User:
        user = await self.find_user_by_id(user_id)

        if not user:
            raise ResourceNotFoundError('User')

        async with self.session.begin_nested():
            user.first_name = first_name
            user.last_name = last_name
            user.onboarded = True

        return user

    async def authenticate_with_creds(self, email: str, password: str) -> User:
        email = email.lower()
        user = await self.session.scalar(select(User).where(User.email == email))
        if not user:
            raise AuthenticationFailedError('Invalid credentials')

        password_is_correct = checkpw(
            password.encode('utf-8'),
            user.hashed_password if user.hashed_password else b''
        )
        if not password_is_correct:
            raise AuthenticationFailedError('Invalid credentials')

        if not user.email_confirmed:
            raise AuthenticationFailedError('Email not confirmed.')

        return user

    async def authenticate_with_email_confirmation(self, email_confirmation_token: str) -> User:
        user = await self.session.scalar(select(User).where(User.email_confirmation_token == email_confirmation_token))
        if not user:
            raise AuthenticationFailedError('Invalid token')

        await self.confirm_user_email(user)
        return user

    async def authenticate_with_google(self, google_id_token: str) -> User:
        idinfo = id_token.verify_oauth2_token(
            id_token_string, Request(), settings.GOOGLE_CLIENT_ID  # type: ignore
        )
        email = idinfo.get('email')
        if not email:
            raise AuthenticationFailedError('Invalid token')

        email = email.lower()
        user = await self.session.scalar(select(User).where(User.email == email))

        if not user:
            user = User(
                email=email,
                source="SELF_SIGNUP",
                email_confirmed=True,
            )
            async with self.session.begin_nested():
                self.session.add(user)
            return user

        await self.confirm_user_email(user)
        return user


    async def authenticate_with_invitation(self, invitation_token: str) -> User:
        membership = await self.session.scalar(
            select(Membership).where(Membership.invitation_token == invitation_token)
        )

        if not membership:
            raise AuthenticationFailedError('Invalid invitation token')

        user = membership.user
        await self.confirm_user_email(user)

        return user


    async def confirm_user_email(self, user: User) -> None:
        async with self.session.begin_nested():
            user.email_confirmed = True
            user.email_confirmation_token = None
            user.email_confirmation_token_sent_at = None

    async def create_password_reset(self, email: str) -> bool:
        user = await self.session.scalar(select(User).where(User.email == email))
        if not user:
            return True

        async with self.session.begin_nested():
            user.pass_reset_token = uuid4()
            user.pass_reset_token_created_at = datetime.now()

        logging.info(f">>>>>>>>>>> SEND EMAIL: {self.get_pass_reset_link(user)} to {email}")

        return True

    async def get_password_reset(self, pass_reset_token: str) -> User:
        user = await self.session.scalar(select(User).where(User.pass_reset_token == pass_reset_token))

        if not user or not user.pass_reset_token or not user.pass_reset_token_created_at:
            raise ValueError('Invalid password reset link')

        return user

    async def update_password_reset(self, pass_reset_token: str, new_password: str) -> bool:
        user = await self.get_password_reset(pass_reset_token)

        twenty_four_hours_ago = datetime.now() - timedelta(hours=24)
        if user.pass_reset_token_created_at and user.pass_reset_token_created_at < twenty_four_hours_ago:
            raise ValueError('Password reset link expired')

        async with self.session.begin_nested():
            user.hashed_password = hashpw(new_password.encode('utf-8'), gensalt())
            user.pass_reset_token = None
            user.pass_reset_token_created_at = None

        return True

    async def create_access_token(self, user_id: str) -> str:
        payload = {
            'exp': datetime.now() + timedelta(weeks=1),
            'aud': settings.SERVICE_NAME,
            'iss': settings.SERVICE_NAME,
            'sub': user_id
        }
        return encode(payload, settings.JWT_SECRET, algorithm='HS256')

    async def verify_access_token(self, access_token: str) -> str:
        try:
            decoded = decode(
                jwt=access_token,
                key=settings.JWT_SECRET,
                algorithms=['HS256'],
                audience=settings.SERVICE_NAME,
                issuer=settings.SERVICE_NAME
            )
            user_id: str = decoded['sub']
            return user_id
        except Exception as error:
            raise AuthenticationFailedError(f"access token verification failed: {str(error)}")

    async def find_user_by_id(self, user_id: str) -> User:
        user = await self.session.scalar(select(User).where(User.id == user_id))
        if not user:
            raise ResourceNotFoundError('User')

        return user

    def get_confirmation_link(self, user: User) -> str:
        return f"http://localhost:3000/confirm/{user.email_confirmation_token}"

    def get_pass_reset_link(self, user: User) -> str:
        return f"http://localhost:3000/new-password/{user.pass_reset_token}"


AuthServiceDep = Annotated[AuthService, Depends(AuthService)]