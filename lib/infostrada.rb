require 'rubygems'

require 'httparty'

module Infostrada
  # The configuration of the API requests.
  class Configuration
    attr_reader :username, :password, :timeout, :retries, :domain

    def username=(username)
      BaseRequest.default_options[:basic_auth].merge!(username: username)
      @username = username
    end

    def password=(password)
      BaseRequest.default_options[:basic_auth].merge!(password: password)
      @password = password
    end

    def timeout=(timeout)
      BaseRequest.default_options[:basic_auth].merge!(password: password)
      @timeout = timeout
    end

    def retries=(retries)
      @retries = retries
    end

    def domain=(domain)
      @domain = domain
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

require 'infostrada/core_ext/string'

require 'infostrada/competition'

require 'infostrada/edition'
require 'infostrada/edition_request'

require 'infostrada/errors'

require 'infostrada/nation'

require 'infostrada/formatter'

require 'infostrada/team'
require 'infostrada/team_request'
require 'infostrada/team_info'

require 'infostrada/match'
require 'infostrada/phase'
require 'infostrada/table'

require 'infostrada/squad'
require 'infostrada/player'
require 'infostrada/person_info'

require 'infostrada/call_refresh'

require 'infostrada/version'