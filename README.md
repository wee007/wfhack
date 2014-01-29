#Customer Console

Formerly known as Playa, premium, presentationlayer, prince, so on.

* How to run the test suite

`bundle exec rake`

* How to start up the dev env

      $ ln -s .env.development .env
      $ foreman start

* Deployment instructions

Coming soon. For now whenever a spec build passes an rpm should be built and installed.


* Host file
Add this to your hostfile, this will point all services at production.
10.3.14.210  event-service.development.dbg.westfield.com
10.3.14.210  centre-service.development.dbg.westfield.com
10.3.14.210  stream-service.development.dbg.westfield.com
10.3.14.210  store-service.development.dbg.westfield.com
10.3.14.210  deal-service.development.dbg.westfield.com
10.3.14.210  customer-service.development.dbg.westfield.com
10.3.14.210  movie-service.development.dbg.westfield.com
10.3.14.210  search-service.development.dbg.westfield.com
10.3.14.210  product-service.development.dbg.westfield.com
10.3.14.210  canned-search-service.development.dbg.westfield.com
