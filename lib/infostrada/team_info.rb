require 'infostrada/base_request'

module Infostrada
  class TeamInfo < Infostrada::BaseRequest
    attr_accessor :official_name, :official_short_name, :public_name, :public_short_name, :nickname
    attr_accessor :foundation_date, :official_stadium_name, :stadium_name, :stadium_capacity
    attr_accessor :url, :city, :country, :country_short_name

    URL = '/GetTeamInfo'

    def self.fetch(team_id)
      info_hash = get!(URL, query: { teamid: team_id.to_i })

      info_hash.first ? self.new(info_hash.first) : nil
    end

    def initialize(hash)
      @official_name          = hash['c_OfficialName']
      @official_short_name    = hash['c_OfficialNameSort']
      @public_name            = hash['c_PublicName']
      @public_short_name      = hash['c_PublicNameSort']
      @nickname               = hash['c_Nickname']
      @foundation_date        = hash['d_FoundationDate']
      @official_stadium_name  = hash['c_StadiumOfficialName']
      @stadium_name           = hash['c_Stadium']
      @stadium_capacity       = hash['n_StadiumCapacity']
      @url                    = hash['c_URL']
      @city                   = hash['c_City']
      @country                = hash['c_Country']
      @country_short_name     = hash['c_CountryShort']

      self
    end
  end
end