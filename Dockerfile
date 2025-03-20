FROM python:3.12-slim-bookworm

COPY --from=ghcr.io/astral-sh/uv:0.6.7 /uv /uvx /bin/
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app

RUN --mount=type=cache,target=/root/.cache/uv \
  --mount=type=bind,source=uv.lock,target=uv.lock \
  --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
  uv sync --frozen --no-install-project

COPY ./pyproject.toml ./uv.lock  /app/
COPY ./app /app/app

RUN --mount=type=cache,target=/root/.cache/uv \
  uv sync --frozen

CMD ["fastapi", "run", "app/main.py"]
