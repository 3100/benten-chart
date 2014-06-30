module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
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
        files:
          'public/js/app.js' : [
            'src/coffee/benten-chart.processed.coffee'
            'src/coffee/renderer.coffee'
          ]
        #cwd: 'src/coffee/'
        #src: ['**/*.coffee']
        #dest: 'public/js/'
        #ext: 'app.js'
        options:
          # グローバル名前空間保護しない
          bare: true
          join: true
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
  grunt.registerTask 'default', ['connect', 'watch']
  grunt.registerTask 'heroku', ['preprocess', 'coffee:compile', 'coffee:express', 'compass:dist']
  return
