Benten Chart
---

## uses

* vue.js
* linq.js
* jQuery
* highcharts
* Gumby

## environments

* BENTEN_API_ORDERS_URL

## development

This project uses `coffeesciprt` and `compass` (mainly for `sass`).

For processing files:

~~~
$ grunt heroku
~~~

For developping:

~~~
$ grunt
~~~

## deploy to heroku

To let `compass` work well on `heroku`, use a custom buildpack like below:

~~~
heroku config:set BUILDPACK_URL=https://github.com/treasure-data/heroku-buildpack-nodejs-grunt-compass-configurable.git
~~~

cf. https://github.com/treasure-data/heroku-buildpack-nodejs-grunt-compass-configurable.git
