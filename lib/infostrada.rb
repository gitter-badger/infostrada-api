require 'rubygems'

require 'httparty'

require 'infostrada/base'
require 'infostrada/edition'
require 'infostrada/team'
require 'infostrada/version'

module Infostrada
  BASE_URI = 'demo.api.infostradasports.com'
  BASE_PATH = '/svc/Football.svc/json/'
  DEMO_AUTH = { username: 'APIdemo', password: 'Sauv@k@vel4' }
end