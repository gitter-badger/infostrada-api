module Infostrada
  class Player
    attr_accessor :person_id, :name, :short_name, :birthdate, :function, :shirt_number
    attr_accessor :season_stats, :nation, :contract_starts_at, :contract_ends_at

    # The function_type variable maps Infostradas n_FunctionType and can have one of these values:
    #
    # 1 = Keeper
    # 2 = Defender
    # 4 = Midfielder
    # 8 = Forward
    # 16 = Trainer
    # 64 = Referee
    # 128 = Linesman
    # 1073741824 = 4th Official
    attr_accessor :function_type

    def initialize(hash)
      @person_id   = hash['n_PersonID']
      @name = hash['c_Person']
      @short_name = hash['c_PersonShort']

      @birthdate = Formatter.format_date(hash['d_BirthDate'])

      # Function is one string like "Goalkeeper", "Defender", "Midfielder", "Forward", "Coach"...
      # Infostrada doesn't document the function strings so you should rely on function_type
      @function = hash['c_Function']
      @function_type = hash['n_FunctionType']
      @shirt_number = hash['n_ShirtNr']

      @contract_starts_at = Formatter.format_date(hash['d_ContractStartDate'])
      @contract_ends_at = Formatter.format_date(hash['d_ContractEndDate'])

      # Season statistics
      set_season_stats(hash)

      @nation = Nation.new(hash, 'person')

      self
    end

    def name?
      @name && !@name.empty?
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
  end
end

