FROM node:20.13.1-alpine

RUN mkdir -p /usr/src/freeapi && chown -R node:node /usr/src/freeapi

WORKDIR /usr/src/freeapi

# Copy package json and yarn lock only to optimise the image building
COPY package.json yarn.lock ./

# copy prepare.js prior. It will be executed after package installation and before ROOT dir is cloned
COPY prepare.js ./

USER node

# Set CI=true to skip Husky setup in prepare.js, and install only production dependencies
ENV CI=true
RUN yarn install --pure-lockfile --production --ignore-optional

COPY --chown=node:node . .

EXPOSE 8080

CMD [ "npm", "start" ]