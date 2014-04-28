require 'infostrada/match_event'

module Infostrada
  class MatchEventList < Infostrada::BaseRequest
    URL = '/GetMatchActionList_All'

    attr_accessor :events

    def self.where(options = {})
      match_id = options.delete(:match_id)

      list = get!(URL, query: { matchid: match_id.to_i })

      events = []
      list.each do |event_hash|
        events << MatchEvent.new(match_id.to_i, event_hash)
      end

      events
    end
  end
end