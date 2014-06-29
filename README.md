Benten Chart
---

## uses

* vue.js
* linq.js
* jQuery
* Gumby
* grunt

## environments

* BENTEN_API_ORDERS_URL

## development

For processing files:

~~~
$ grunt
~~~

## deploy to heroku

To let `compass` works well on `heroku`, use a custom buildpack like below:

~~~
heroku config:set BUILDPACK_URL=https://github.com/treasure-data/heroku-buildpack-nodejs-grunt-compass-configurable.git
~~~
