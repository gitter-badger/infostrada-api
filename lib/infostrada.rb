require 'rubygems'

require 'httparty'

module Infostrada
  BASE_URI = 'demo.api.infostradasports.com'
  BASE_PATH = '/svc/Football.svc/json/'
  DEMO_AUTH = { username: 'APIdemo', password: 'Sauv@k@vel4' }
end

require 'infostrada/core_ext/string'

require 'infostrada/base_request'
require 'infostrada/competition'

require 'infostrada/edition'
require 'infostrada/edition_request'

require 'infostrada/errors'

require 'infostrada/nation'

require 'infostrada/team'
require 'infostrada/team_request'
require 'infostrada/team_info'

require 'infostrada/squad'
require 'infostrada/player'

require 'infostrada/version'