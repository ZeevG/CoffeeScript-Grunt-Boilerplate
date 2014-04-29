module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    
    # Check Coffee
    coffeelint:
      app: ['src/**/*.coffee']
      options:
        'no_trailing_whitespace':
          level: 'warn'
        'max_line_length':
          level: 'warn'
        'no_unnecessary_fat_arrows':
          level: 'error'
        'no_tabs':
          level: 'warn'
        'indentation':
          level: 'warn'
        'camel_case_classes':
          level: 'warn'

    # Browserify JS
    browserify:
      app:        
        files:
          'dist/js/app.js': ['src/js/app.coffee']
        options:
          transform: ['coffeeify']
          bundleOptions:
            debug: true
          shim:
            jquery:
              path: 'node_modules/jquery/dist/jquery.min.js'
              exports: '$'
          
    # Copy assets
    copy:
      dist:
        files:
          [
            {expand: true, cwd: 'src/fonts/', src: ['*'], dest: 'dist/fonts/', filter: 'isFile'}
            {expand: true, cwd: 'src/images/', src: ['**'], dest: 'dist/images/'}
            {expand: true, cwd: 'src/css/', src: ['*.css'], dest: 'dist/css/', filter: 'isFile'}
          ]

    # Minify HTML
    htmlmin:
      dist:
        options:
          removeComments: true,
          collapseWhitespace: true,
          removeEmptyAttributes: true,
          removeCommentsFromCDATA: true,
          removeRedundantAttributes: true,
          collapseBooleanAttributes: true 
        files:
          'dist/index.html': 'src/index.html'

     # Minify CSS
    cssmin:
      release:
        files:
          'dist/css/vendor.css': ['src/css/vendor/*.css']

    # Clean directories
    clean:
      build: ["dist"]
    
    # Server
    connect:
      server:
        options:
          port: 3000,
          base: 'dist/'

    # Watch
    watch:
      livereload:
        files: ["dist/**/*", "dist/*"]
        options:
          livereload: true
      js:
        files: ["Gruntfile.coffee", "src/**/*.coffee", "src/**/*.js"]
        tasks: ["coffeelint", "copy:dist", "browserify"]
      html:
        files: ["src/*.html"]
        tasks: ["htmlmin"]
      css:
        files: ["src/**/*.css"]
        tasks: ["cssmin", "copy:dist"]

  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-htmlmin"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-browserify"


  grunt.registerTask "dev", ["coffeelint", "clean:build", "browserify:app", "copy", "htmlmin", "cssmin", "connect", "watch"]
  grunt.registerTask "default", ["dev"]
