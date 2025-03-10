FROM node:8.9.3-alpine

WORKDIR /usr/src/app

COPY ./app/package.json .

RUN npm install

USER node

COPY --chown=node:node ./app .

EXPOSE 8080

CMD [ "node", "index.js" ]