module Infostrada
  class Squad < Infostrada::BaseRequest
    URL = '/GetSquad'

    def self.where(options = {})
      edition_id = options.delete(:edition_id)
      team_id = options.delete(:team_id)

      list = get(URL, query: { editionid: edition_id, teamid: team_id })

      players = []
      list.each do |player_hash|
        players << Player.new(player_hash)
      end

      players
    end
  end
end