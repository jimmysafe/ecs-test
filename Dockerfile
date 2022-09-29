FROM amd64/node:14-alpine As development

WORKDIR /app

COPY --chown=node:node package*.json ./

RUN yarn

COPY --chown=node:node . .

EXPOSE 4000

CMD [ "yarn", "start" ]




