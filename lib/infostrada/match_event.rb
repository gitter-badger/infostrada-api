module Infostrada
  # MatchEvent can have a lot of different events in a match.
  #
  # Here's a list of the n_ActionSet values, from Infostrada FAQ:
  #
  # 1 = Goals
  # 2 = Penalty shootout
  # 3 = Cards
  # 4 = Line-up
  # 5 = Substitutions
  # 6 = Substitutes not used
  # 7 = Players not selected / suspended
  # 8 = Coaches
  # 9 = Officials
  # 10 = Missed penalties
  # 11 = Captain
  # 12 = Free kick / Foul / Corner / Offside / Shot / Save
  # 13 = Possession
  # 14 = Temporarily out
  # 15 = Other
  # 16 = Time
  #
  # period_code is taken from Infostradas n_PeriodSort, that can have one of these values:
  #
  # 1 = Not started
  # 2 = 1st Half
  # 3 = Halftime
  # 4 = 2nd Half
  # 5 = 90 mins
  # 6 = 1st Extra Time
  # 7 = 105 mins
  # 8 = 2nd Extra Time
  # 9 = 120 mins
  # 10 = Penalty Shootout
  # 11 = End
  class MatchEvent
    attr_accessor :id, :description, :short_description, :period, :period_short, :time, :home_goals
    attr_accessor :away_goals, :home_event, :team_id, :team_name, :team_short_name, :person_id
    attr_accessor :person_name, :person_short_name, :reason, :info, :person2_id, :person2_name
    attr_accessor :person2_short_name, :minute, :match_id, :action_set, :period_code, :action_sort

    # These action codes are documented on the Infostrada ADVANCED PROGRAMMING documentation
    attr_accessor :action_code, :action_code_2, :action_code_3

    def initialize(match_id, hash)
      @match_id = match_id

      @id                 = hash['n_ActionID']
      @description        = hash['c_Action']
      @short_description  = hash['c_ActionShort']
      @period             = hash['c_Period']
      @period_short       = hash['c_PeriodShort']
      @period_code        = hash['n_PeriodSort']
      @time               = hash['n_ActionTime']
      @home_goals         = hash['n_HomeGoals']
      @away_goals         = hash['n_AwayGoals']
      @home_event         = hash['n_HomeOrAway'] == 1 ? true : false
      @team_id            = hash['n_TeamID']
      @team_name          = hash['c_Team']
      @team_short_name    = hash['c_TeamShort']
      @person_id          = hash['n_PersonID']
      @person_name        = hash['c_Person']
      @person_short_name  = hash['c_PersonShort']
      @reason             = hash['c_ActionReason']
      @info               = hash['c_ActionInfo']
      @person2_id         = hash['n_SubPersonID']
      @person2_name       = hash['c_SubPerson']
      @person2_short_name = hash['c_SubPersonShort']
      @minute             = hash['c_ActionMinute']
      @action_set         = hash['n_ActionSet']
      @action_code        = hash['n_ActionCode']
      @action_code_2      = hash['n_ActionCode2']
      @action_code_3      = hash['n_ActionCode3']
      @action_sort        = hash['n_ActionSort']

      self
    end

    def attributes=(hash)
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    def attributes
      instance_values
    end
  end
end