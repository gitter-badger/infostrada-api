require 'rubygems'

require 'httparty'

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

require 'infostrada/squad'
require 'infostrada/player'
require 'infostrada/person_info'

require 'infostrada/version'

module Infostrada
  # The configuration of the API requests. This configuration is also shared by
  # <Infostrada::BaseRequest> where the HTTParty configuration is done.
  class Configuration
    attr_reader :user, :password, :timeout

    def initialize
      BaseRequest.default_options[:basic_auth] ||= {}
    end

    def user=(user)
      BaseRequest.default_options[:basic_auth].merge!(username: user)
      @user = user
      self
    end

    def password=(password)
      BaseRequest.default_options[:basic_auth].merge!(password: password)
      @password = password
      self
    end

    def timeout=(timeout)
      BaseRequest.default_options[:timeout] = timeout
      @timeout = timeout
      self
    end
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end