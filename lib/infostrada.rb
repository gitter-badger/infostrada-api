require 'rubygems'
require 'httparty'
require 'active_model'

require 'infostrada/core_ext/string'
require 'infostrada/base_request'

module Infostrada
  extend ActiveModel::Serializers::JSON

  # The configuration of the API requests.
  class Configuration
    attr_reader :username, :password, :timeout, :base_uri
    attr_accessor :last_update_file, :retries

    def username=(username)
      BaseRequest.default_options[:basic_auth] ||= {}
      BaseRequest.default_options[:basic_auth].merge!(username: username)
      @username = username
    end

    def password=(password)
      BaseRequest.default_options[:basic_auth] ||= {}
      BaseRequest.default_options[:basic_auth].merge!(password: password)
      @password = password
    end

    # Default timeout is 15 seconds.
    def timeout=(timeout)
      BaseRequest.default_timeout(timeout)
      @timeout = timeout
    end

    # Base URI of the service. Since the gem is only football related for now we can have the
    # football path already in the base_uri.
    def domain=(domain)
      base_uri = "#{domain}/svc/Football.svc/json/"

      BaseRequest.base_uri(base_uri)
      @base_uri = base_uri
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

require 'infostrada/version'