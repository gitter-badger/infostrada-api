module Infostrada
  class Table < Infostrada::BaseRequest
    include Enumerable

    attr_accessor :edition_id, :phase_id, :entries

    URL = '/GetTable'

    def self.where(options = {})
      phase_id = options.delete(:phase_id)

      list = get!(URL, query: { phaseid: phase_id })

      table = Table.new(phase_id, list)
    end

    def initialize(phase_id, table_list)
      @phase_id = phase_id

      @entries = []
      table_list.each do |hash|
        @edition_id ||= hash['n_EditionID']
        @entries << TableEntry.new(hash)
      end

      self
    end

    def each(&block)
      @entries.each(&block)
    end
  end

  class TableEntry
    attr_accessor :team_id, :rank, :matches, :matches_won, :matches_drawn
    attr_accessor :matches_lost, :points, :goals_for, :goals_against

    def initialize(hash)
      @team_id = hash['n_TeamID']
      @rank = hash['n_RankSort']
      @matches = hash['n_Matches']
      @matches_won = hash['n_MatchesWon']
      @matches_drawn = hash['n_MatchesDrawn']
      @matches_lost = hash['n_MatchesLost']
      @points = hash['n_Points']
      @goals_for = hash['n_GoalsFor']
      @goals_against = hash['n_GoalsAgainst']
    end
  end
end