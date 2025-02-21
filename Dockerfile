# ---- Base Node ----
FROM node:20-bullseye AS base
RUN apt-get update
RUN apt-get install openssl
LABEL image=timothyjmiller/prisma-studio:latest \
  maintainer="Timothy Miller <tim.miller@preparesoftware.com>" \
  base=debian

# ---- Dependencies ----
FROM base AS dependencies
COPY package.json ./
COPY pnpm-lock.yaml ./

RUN npm install -g pnpm
RUN pnpm install --prod

# ---- Release -----
FROM base AS release
COPY --from=dependencies /node_modules ./node_modules

COPY prisma-introspect.sh .
RUN chmod +x prisma-introspect.sh

EXPOSE $PRISMA_STUDIO_PORT
ENTRYPOINT ["/bin/sh", "prisma-introspect.sh"]