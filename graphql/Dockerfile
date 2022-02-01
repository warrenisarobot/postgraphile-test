FROM node:alpine
LABEL description="Instant high-performance GraphQL API for your PostgreSQL database https://github.com/graphile/postgraphile"

RUN mkdir /usr/local/graph-server
ADD package.json /usr/local/graph-server
WORKDIR /usr/local/graph-server
RUN npm install

EXPOSE 5000
#ENTRYPOINT ["postgraphile", "-n", "0.0.0.0"]
ENTRYPOINT ["node", "./init.js"]
