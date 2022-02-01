CREATE ROLE keycloak WITH LOGIN PASSWORD 'keycloakdbpassword';

CREATE SCHEMA keycloak;

GRANT ALL PRIVILEGES ON SCHEMA keycloak TO keycloak;
