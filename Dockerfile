FROM node:10.16.0-alpine AS build

RUN set -x && apk update && apk upgrade \
    # used by npm to fetch some dependencies
    && apk add --no-cache git openssh \
    # used to build node-sass package
    && apk add --no-cache make g++ python

COPY docker/envfile.sh /usr/local/bin/envfile

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . ./
RUN envfile prefill .env.example .env && npm run build

FROM nginx:1.16.0-alpine as prod
COPY docker/envfile.sh /usr/local/bin/envfile
COPY docker/nginx-web.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=build /app/.env .env.prefilled
EXPOSE 80
CMD envfile resolve .env.prefilled /usr/share/nginx/html && nginx -g "daemon off;"
