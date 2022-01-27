This is a postgraphile test that uses the 2 tables in the postgraphile examples, and adds row-level security, auto-creates roles when users are added and creates example data.

On first start run:

`docker-compose build`

Then to start postgres and graphile do:

`docker-compose up`


This setup is creating a new role for every user.  This will eventually create a very large number of roles.  This does make it, though, so that nobody can see other user data unless they can use a different role during the query.  If security makes it so that someone logged in to the db cannot use a user role then it protects that data.  How hard is this to do in practice, though?

An alternative is to have 2 roles:
* admin role (like it is now)
* user_access role.  

The row based security would have the separate see-everything security for admins, and then for public it would look for the local variable `jwt.claims.user_id` .  This makes roles easier to see and manage.  It does also mean, though, that anybody connected can set the `jwt.claims.user_id` variable for their connection and get other user data.  Information about which variables are set [is here](https://www.graphile.org/postgraphile/security/#how-it-works).



test user in keycloak to get token:

curl -L -X POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' \
-H 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'client_id=postgraphile' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_secret=91086564-6473-460e-82d9-4142faddf0c3' \
--data-urlencode 'scope=openid' \
--data-urlencode 'username=test' \
--data-urlencode 'password=test'
