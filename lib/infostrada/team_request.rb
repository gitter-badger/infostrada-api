module Infostrada
  class TeamRequest < Infostrada::BaseRequest
    URLS = {
      list: '/GetTeamList'
    }

    def self.get_edition(edition_id)
      list = get(URLS[:list], query: { editionid: edition_id.to_i })

      teams = []
      list.each do |team_hash|
        teams << Team.new(team_hash)
      end

      teams
    end
  end
end