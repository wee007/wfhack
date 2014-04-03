#Customer Console

Formerly known as Playa, premium, presentationlayer, prince, so on.

* Dependencies
This project uses bundler and bower for dependency management. To install bower you'll need to get npm.

      $ bundle install
      $ npm install bower
      $ bower install
      $ npm install -g karma@0.8.8
      $ brew install phantomjs

* How to run the test suite

`bundle exec rake`

* How to start up the dev env

      $ ln -s .env.development .env
      $ foreman start

* Deployment instructions

Coming soon. For now whenever a spec build passes an rpm should be built and installed.


* Host file
Add this to your hostfile, this will point all services at production.
<pre>
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
</pre>

* Gotchas
You'd think customer-service.systest.dbg.westfield.com and customer-service.uat.dbg.westfield.com are the urls for systest and uat.
You'd think wrong. These URLS don't provide browsers with access to the any services except indirectly.

For systest and uat, use the following URLS:
http://wwwau.systest.dbg.westfield.com/
and
http://www.uat.westfield.com.au/
