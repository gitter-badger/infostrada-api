module Infostrada
  class Team < Infostrada::Base
    PATH = 'GetTeamList?editionId=%d&languageCode=%d'
    PATH = 'GetTeamInfo?TeamID=4080&LanguageCode=2'

    class << self
      def list
        httparty.get
      end
    end
  end
end