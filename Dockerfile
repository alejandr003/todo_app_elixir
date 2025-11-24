FROM elixir:1.16-alpine AS builder

RUN apk add --no-cache build-base git nodejs npm

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config

ENV MIX_ENV=prod
RUN mix deps.get --only prod && \
    mix deps.compile

# --- ASSETS BUILD ---
COPY assets assets
COPY package.json ./assets/
WORKDIR /app/assets
RUN npm install
RUN npm run deploy
WORKDIR /app

COPY lib lib
COPY priv priv

RUN mix do compile, release
# --- FIN ASSETS BUILD ---

FROM alpine:3.19 AS runner

RUN apk add --no-cache \
    libstdc++ \
    openssl \
    ncurses-libs \
    ca-certificates

RUN addgroup -g 1000 app && \
    adduser -D -u 1000 -G app app

WORKDIR /app

COPY --from=builder --chown=app:app /app/_build/prod/rel/todo_app ./
COPY --from=builder --chown=app:app /app/priv ./priv

USER app

ENV HOME=/app

EXPOSE 4000

CMD ["bin/todo_app", "start"]