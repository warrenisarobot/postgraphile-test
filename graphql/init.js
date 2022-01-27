#!/usr/bin/env node

const express = require("express");
const { postgraphile } = require("postgraphile");
const jwt = require("express-jwt");
const jwksRsa = require("jwks-rsa");
const httpProxy = require("http-proxy");
const reverseProxy = httpProxy.createProxyServer();

const app = express();
const port = process.env.PORT || 5434;

const authErrors = (err, req, res, next) => {
  if (err.name === "UnauthorizedError") {
    console.log("Auth error:" + err); // You will still want to log the error...
    // but we don't want to send back internal operation details
    // like a stack trace to the client!
    res.status(err.status).json({ errors: [{ message: err.message }] });
    res.end();
  }
};

const checkJwt = jwt({
  // Dynamically provide a signing key
  // based on the `kid` in the header and
  // the signing keys provided by the JWKS endpoint.
  secret: jwksRsa.expressJwtSecret({
    cache: true,
    rateLimit: true,
    jwksRequestsPerMinute: 5,
    jwksUri:
      `http://keycloak:8080/auth/realms/master/protocol/openid-connect/certs`,
  }),

  // Validate the audience and the issuer.
  audience: "postgraphile",
  issuer: `http://2c62-174-52-91-94.ngrok.io/auth/realms/master`,
  algorithms: ["RS256"],
});

app.all("/auth/token", function (req, res) {
  console.log("hit auth endpoint");
  console.log("Request: " + req);
  req.path = "/auth/realms/master/protocol/openid-connect/token";
  res = reverseProxy.web(req, res, {
    target:
      "http://keycloak:8080/auth/realms/master/protocol/openid-connect/token",
    ignorePath: true,
  });
  console.log("result: " + res);
});

app.use(checkJwt);

app.use(authErrors);

app.use(
  postgraphile(
    process.env.DATABASE_URL || "postgres://user:pass@host:5432/dbname",
    "public",
    {
      watchPg: true,
      graphiql: true,
      enhanceGraphiql: true,
      jwtRole: ["jti"],
      pgSettings: (req) => {
        const settings = {};
        if (req.user) {
          console.log("User: %j", req.user);
          settings["user.id"] = req.user.jti;
          console.log("Settings: %j", settings);
        }
        return settings;
      },
    },
  ),
);

console.log("Starting listener on port " + port);

app.listen(port);
