FROM node:alpine
LABEL description="Instant high-performance GraphQL API for your PostgreSQL database https://github.com/graphile/postgraphile"

# Install PostGraphile and PostGraphile connection filter plugin
ADD package.json /tmp/
WORKDIR /tmp
RUN ls -lah
RUN npm install

EXPOSE 5000
#ENTRYPOINT ["postgraphile", "-n", "0.0.0.0"]
ENTRYPOINT ["/tmp/init.js"]
