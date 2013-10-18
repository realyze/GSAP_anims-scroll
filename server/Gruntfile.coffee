path = require 'path'

module.exports = (grunt) ->

  grunt.initConfig
    express:
      options:
        cmd: 'coffee'
        delay: 50
      dev:
        options:
          script: path.join(__dirname, 'app.coffee')
          node_env: 'dev'

    watch:
      express:
        files:  [ '**/*.coffee' ]
        tasks:  [ 'test', 'express:dev' ]
        options:
          nospawn: true
      test:
        files: ['**/*.coffee']
        tasks:  [ 'test' ]

    mochaTest:
      options:
        compilers: 'coffee-script'

      test:
        options:
          reporter: 'dot'
        src: ['!node_modules/**', '**/*.spec.coffee']

      jenkins:
        options:
          reporter: 'xunit-file'
        src: ['!node_modules/**', '**/*.spec.coffee']

    env:
      jenkins:
        XUNIT_FILE: 'test-results-server.xml'

  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-env'

  grunt.registerTask 'default', ['dev']

  grunt.registerTask 'dev', ['express:dev', 'test', 'watch:test']

  grunt.registerTask 'test', ['mochaTest:test']
  grunt.registerTask 'test:jenkins', ['env:jenkins', 'mochaTest:jenkins']
