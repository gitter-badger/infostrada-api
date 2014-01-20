module Infostrada
  class Squad < Infostrada::BaseRequest
    URLS = {
      get: '/GetSquad'
    }

    def self.where(options = {})
      edition_id = options.delete(:edition_id)
      team_id = options.delete(:team_id)

      list = get(URLS[:get], query: { editionid: edition_id, teamid: team_id })

      players = []
      list.each do |player_hash|
        players << Player.new(player_hash)
      end

      players
    end
  end
end