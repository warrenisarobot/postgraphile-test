#!/usr/bin/env node

const express = require("express");
const { postgraphile } = require("postgraphile");
const jwt = require("express-jwt");
const jwksRsa = require("jwks-rsa");

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
    jwksUri: `https://dev-7o44e5n5.us.auth0.com/.well-known/jwks.json`,  }),

  // Validate the audience and the issuer.
  audience: "postgraphile",  issuer: `https://dev-7o44e5n5.us.auth0.com/`,  algorithms: ["RS256"],
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
        pgSettings: req => {
            const settings = {};
            if (req.user) {
                settings["user.permissions"] = req.user.scopes;
            }
            return settings;
        }
    }
  )
);





console.log("Starting listener on port " + port);

app.listen(port);
