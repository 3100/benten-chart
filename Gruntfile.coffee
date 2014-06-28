module.exports = (grunt) ->
  # Gruntの設定
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    watch:
      options:
        livereload: true
      coffee:
        tasks: 'coffee'
        files: ['src/**/*.coffee']
      html:
        files: ['html/**/*.html']
      js:
        files: ['js/**/*.js']
      css:
        files: ['css/**/*.css']
    coffee:
      compile:
        expand: true
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'js/'
        ext: '.js'
        options:
          # グローバル名前空間保護しない
          bare: true
    connect:
      server:
        options:
          port: 9000
          #base: 'html'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.registerTask 'default', ['connect', 'watch']
  return
