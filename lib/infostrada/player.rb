module Infostrada
  class Player
    attr_accessor :person_id, :name, :short_name, :birthdate, :function, :shirt_number
    attr_accessor :season_stats, :nation

    def initialize(hash)
      @person_id   = hash['n_PersonID']
      @name = hash['c_Person']
      @short_name = hash['c_PersonShort']

      @birthdate = Formatter.format_date(hash['d_BirthDate'])

      # Function can be one of the folowing strings:
      # "Goalkeeper", "Defender", "Midfielder", "Forward" or "Coach"
      @function = hash['c_Function']
      @shirt_number = hash['n_ShirtNr']

      # Season statistics
      set_season_stats(hash)

      @nation = Nation.new
      set_nation_attributes(hash)
    end

    private

    def set_season_stats(hash)
      @season_stats = {}

      @season_stats[:matches]               = hash['n_Matches']
      @season_stats[:matches_start]         = hash['n_MatchesStart']
      @season_stats[:matches_out]           = hash['n_MatchesOut']
      @season_stats[:matches_in]            = hash['n_MatchesIn']
      @season_stats[:minutes_played]        = hash['n_MinutesPlayed']
      @season_stats[:goals]                 = hash['n_Goals']
      @season_stats[:own_goals]             = hash['n_OwnGoals']
      @season_stats[:assists]               = hash['n_Assists']
      @season_stats[:cards_yellow]          = hash['n_CardsYellow']
      @season_stats[:cards_red]             = hash['n_CardsRed']
      @season_stats[:cards_red_direct]      = hash['n_CardsRedDirect']
      @season_stats[:cards_red_from_yellow] = hash['n_CardsRed2Yellow']
    end

    def set_nation_attributes(hash)
      hash.each do |key, value|
        if key =~ /[cn]_\w+Natio.*/
          method = "#{key.snake_case.gsub(/[cn]_person_?/, '')}="
          @nation.send(method, value)
        end
      end
    end
  end
end

