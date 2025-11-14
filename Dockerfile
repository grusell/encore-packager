ARG NODE_IMAGE=node:23-alpine
ARG SHAKA_VERSION=3.4.2
ARG SHAKA_ARCH=x64

# Note: This target is the one build by CI and published to dockerhub
FROM ${NODE_IMAGE} AS without-volume-definition
ARG SHAKA_VERSION
ARG SHAKA_ARCH
ENV NODE_ENV=production
EXPOSE 8000
RUN apk --no-cache add curl
RUN apk --no-cache add aws-cli
RUN curl -L -o /usr/bin/packager https://github.com/shaka-project/shaka-packager/releases/download/v${SHAKA_VERSION}/packager-linux-${SHAKA_ARCH} && chmod a+x /usr/bin/packager
RUN mkdir /app
RUN chown node:node /app
USER node
WORKDIR /app
COPY --chown=node:node ["package.json", "package-lock.json*", "tsconfig*.json", "./"]
COPY --chown=node:node ["src", "./src"]
# Delete prepare script to avoid errors from husky
RUN npm pkg delete scripts.prepare \
    && npm ci --omit=dev
CMD [ "npm", "run", "start", "--", "-r" ]

FROM without-volume-definition
VOLUME [ "/data" ]
ENV STAGING_DIR=/data
ENV TMPDIR=/data
