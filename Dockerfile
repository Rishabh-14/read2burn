####################
# Build application

FROM node:lts-alpine AS builder

ENV READ2BURN_HOME="/app"

WORKDIR ${READ2BURN_HOME}

COPY . .

# Run a command inside the image
# If you are building your code for production
# RUN npm ci --only=production
# else
# RUN npm install
RUN npm ci --only=production \
  && rm -rf ${READ2BURN_HOME}/docker

####################
# Create image

FROM node:lts-alpine

ENV READ2BURN_HOME="/app"

WORKDIR ${READ2BURN_HOME}

COPY --from=builder ${READ2BURN_HOME} .

EXPOSE 3300

VOLUME ["${READ2BURN_HOME}/data"]

CMD ["node", "app.js"]

ARG GIT_COMMIT
LABEL org.opencontainers.image.revision "${GIT_COMMIT}"

ARG BUILD_DATE
LABEL org.opencontainers.image.created "${BUILD_DATE}"