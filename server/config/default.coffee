# Default configuration
# =====================
#
# Can be overriden for developers needs (just create a `development.coffee`
# file with your settings in this directory.

path = require 'path'

module.exports =
  server:
    static_root: path.join __dirname, '../../build'
    views_root: path.join __dirname, '../views'

  log:
    level: 'debug'

  secret:
    wufoo:
      api_key: 'AMMV-RPIL-QK3I-0QID'
      form_id: 'z7x3p3'
