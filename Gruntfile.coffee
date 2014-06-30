module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    env:
      build:
        BENTEN_API_ORDERS_URL: process.env.BENTEN_API_ORDERS_URL || '/orders.json'
    watch:
      options:
        livereload: true
      coffee:
        tasks: ['preprocess', 'coffee:compile']
        files: ['src/coffee/**/*.coffee']
      express:
        tasks: 'coffee:express'
        files: ['app.coffee']
      html:
        files: ['public/**/*.html']
      js:
        files: ['public/js/**/*.js']
      compass:
        files: ['src/sass/**/*.sass']
        tasks: ['compass']
    coffee:
      compile:
        expand: true
        cwd: 'src/coffee/'
        src: ['**/*.coffee']
        dest: 'public/js/'
        ext: '.js'
        options:
          # グローバル名前空間保護しない
          bare: true
      express:
        expand: true
        cwd: '.'
        src: ['app.coffee']
        dest: '.'
        ext: '.js'
    compass:
      dist:
        options:
          sassDir: 'src/sass'
          cssDir: 'public/css'
    connect:
      server:
        options:
          port: 9000
          base: 'public'
    preprocess:
      coffee:
        src: 'src/coffee/benten-chart.coffee'
        dest: 'src/coffee/benten-chart.processed.coffee'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-preprocess'
  grunt.loadNpmTasks 'grunt-env'
  grunt.registerTask 'default', ['connect', 'watch']
  #grunt.registerTask 'heroku', ['env:build', 'preprocess', 'coffee:compile', 'coffee:express', 'compass:dist']
  grunt.registerTask 'heroku', ['preprocess', 'coffee:compile', 'coffee:express', 'compass:dist']
  return
