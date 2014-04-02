module Infostrada
  class MatchEvent
    attr_accessor :id, :description, :short_description, :period, :period_short, :time, :home_goals
    attr_accessor :away_goals, :home_event, :team_id, :team_name, :team_short_name, :person_id
    attr_accessor :person_name, :person_short_name, :reason, :info, :person2_id, :person2_name
    attr_accessor :person2_short_name, :minute

    def initialize(hash)
      @id                 = hash['n_ActionID']
      @description        = hash['c_Action']
      @short_description  = hash['c_ActionShort']
      @period             = hash['c_Period']
      @period_short       = hash['c_PeriodShort']
      @time               = hash['n_ActionTime']
      @home_goals         = hash['n_HomeGoals']
      @away_goals         = hash['n_AwayGoals']
      @home_event         = (hash['n_HomeOrAway'] == 1) ? true : false
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

      self
    end
  end
end