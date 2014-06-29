module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    watch:
      options:
        livereload: true
      coffee:
        tasks: ['preprocess', 'coffee']
        files: ['src/**/*.coffee']
      html:
        files: ['public/**/*.html']
      js:
        files: ['public/js/**/*.js']
      css:
        files: ['public/css/**/*.css']
    coffee:
      compile:
        expand: true
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'public/js/'
        ext: '.js'
        options:
          # グローバル名前空間保護しない
          bare: true
    connect:
      server:
        options:
          port: 9000
          base: 'public'
    preprocess:
      coffee:
        src: 'src/demo.coffee'
        dest: 'src/demo.processed.coffee'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-preprocess'
  grunt.registerTask 'default', ['connect', 'watch']
  return
