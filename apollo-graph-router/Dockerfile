FROM --platform=linux/amd64 debian
WORKDIR /tmp/
RUN apt update
RUN apt install -y wget tar
RUN wget https://github.com/apollographql/router/releases/download/v0.1.0-alpha.3/router-0.1.0-alpha.3-x86_64-linux.tar.gz
RUN mkdir /usr/local/apollo-router
RUN tar -xzvf router-0.1.0-alpha.3-x86_64-linux.tar.gz -C /usr/local/apollo-router
WORKDIR /usr/local/apollo-router
ADD conf/* /usr/local/apollo-router
CMD ["/usr/local/apollo-router/dist/router", "--supergraph", "combined.graphql", "--log", "info", "--config", "router-config.yaml"]
#CMD ["ls", "-lah"]
