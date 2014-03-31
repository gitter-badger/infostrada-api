require 'infostrada/referee'

# Example of Match JSON from Infostrada:
#
# {
#   n_MatchID: 1533036,
#   d_Date: "/Date(1281786300000+0200)/",
#   d_DateLocal: "/Date(1281782700000+0200)/",
#   d_DateUTC: "/Date(1281779100000+0200)/",
#   b_DateUnknown: false,
#   b_TimeUnknown: false,
#   b_RescheduledToBeResumed: false,
#   n_RoundNr: 1,
#   n_PhaseID: 86971,
#   n_PhaseLevel: 1,
#   c_Phase: "Regular",
#   c_PhaseShort: null,
#   n_HomeTeamID: 4129,
#   c_HomeTeam: "Tottenham Hotspur",
#   c_HomeTeamShort: "TOT",
#   n_HomeTeamNatioGeoID: 2208,
#   c_HomeTeamNatio: "England",
#   c_HomeTeamNatioShort: "ENG",
#   n_AwayTeamID: 4222,
#   c_AwayTeam: "Manchester City",
#   c_AwayTeamShort: "MCI",
#   n_AwayTeamNatioGeoID: 2208,
#   c_AwayTeamNatio: "England",
#   c_AwayTeamNatioShort: "ENG",
#   n_StadiumGeoID: 13102,
#   c_Stadium: "White Hart Lane",
#   n_CityGeoID: 25133,
#   c_City: "London",
#   n_CountryGeoID: 2208,
#   c_Country: "England",
#   c_CountryShort: "ENG",
#   c_Score: "0-0 (0-0) ",
#   c_ScoreSuffix: null,
#   n_HomeGoals: 0,
#   n_AwayGoals: 0,
#   n_HomeGoalsHalftime: 0,
#   n_AwayGoalsHalftime: 0,
#   n_HomeGoals90mins: null,
#   n_AwayGoals90mins: null,
#   n_HomeGoals105mins: null,
#   n_AwayGoals105mins: null,
#   n_HomeGoalsShootout: null,
#   n_AwayGoalsShootout: null,
#   n_MatchStatusCode: 128,
#   c_MatchStatus: "Full time",
#   c_MatchStatusShort: "FT",
#   b_Finished: true,
#   b_Awarded: false,
#   b_Abandoned: false,
#   b_Postponed: false,
#   n_RefereeID: 486298,
#   c_Referee: "André Marriner",
#   n_RefereeNatioGeoID: 2208,
#   c_RefereeNatio: "England",
#   c_RefereeNatioShort: "ENG",
#   n_Spectators: 35928,
#   n_KnockoutPhaseID: null,
#   n_Leg: null,
#   c_FirstLegScore: null,
#   n_WinnerOnAggregateTeamID: null,
#   b_DataEntryLiveScore: false,
#   b_DataEntryLiveGoal: false,
#   b_DataEntryLiveLineup: false
# },
module Infostrada
  class Match < Infostrada::BaseRequest
    attr_accessor :id, :date, :rescheduled, :round, :home_team, :away_team, :phase
    attr_accessor :stadium_id, :goals, :match_status, :finished, :awarded, :abandoned
    attr_accessor :postponed, :referee, :spectators, :leg, :knockout_phase, :first_leg_score

    # Check if the live score, live goals and live lineups are already available
    attr_accessor :live_score, :live_goal, :live_lineup

    URLS = {
      list: '/GetMatchList_Edition',
      single: '/GetMatchInfo'
    }

    JSON_TEST = '{"n_MatchID":1787593,"d_Date":"\/Date(1372770000000+0200)\/","d_DateLocal":"\/Date(1372777200000+0200)\/","d_DateUTC":"\/Date(1372762800000+0200)\/","b_DateUnknown":false,"b_TimeUnknown":false,"b_RescheduledToBeResumed":false,"n_RoundNr":1,"n_PhaseID":103951,"n_PhaseLevel":75,"c_Phase":"Qualifying Round 1","c_PhaseShort":"QR1","n_HomeTeamID":4854,"c_HomeTeam":"Shirak Gyumri","c_HomeTeamShort":"SHI","n_HomeTeamNatioGeoID":4317,"c_HomeTeamNatio":"Armenia","c_HomeTeamNatioShort":"ARM","n_AwayTeamID":104919,"c_AwayTeam":"Tre Penne","c_AwayTeamShort":"TPE","n_AwayTeamNatioGeoID":2782,"c_AwayTeamNatio":"San Marino","c_AwayTeamNatioShort":"SMR","n_StadiumGeoID":21736,"c_Stadium":"Gyumri City Stadium","n_CityGeoID":23938,"c_City":"Gyumri","n_CountryGeoID":4317,"c_Country":"Armenia","c_CountryShort":"ARM","c_Score":"3-0 (1-0) ","c_ScoreSuffix":null,"n_HomeGoals":3,"n_AwayGoals":0,"n_HomeGoalsHalftime":1,"n_AwayGoalsHalftime":0,"n_HomeGoals90mins":null,"n_AwayGoals90mins":null,"n_HomeGoals105mins":null,"n_AwayGoals105mins":null,"n_HomeGoalsShootout":null,"n_AwayGoalsShootout":null,"n_MatchStatusCode":128,"c_MatchStatus":"Full time","c_MatchStatusShort":"FT","b_Finished":true,"b_Awarded":false,"b_Abandoned":false,"b_Postponed":false,"n_RefereeID":1186616,"c_Referee":"Aleksandr Aliyev","n_RefereeNatioGeoID":2236,"c_RefereeNatio":"Kazakhstan","c_RefereeNatioShort":"KAZ","n_Spectators":2600,"n_KnockoutPhaseID":103962,"n_Leg":1,"c_FirstLegScore":null,"n_WinnerOnAggregateTeamID":null,"b_DataEntryLiveScore":true,"b_DataEntryLiveGoal":true,"b_DataEntryLiveLineup":true}'

    def self.where(options = {})
      list = get_match_list(options)

      matches = []
      list.each do |match_hash|
        matches << Match.new(match_hash)
      end

      matches
    end

    def self.get_match_list(options)
      edition_id = options.delete(:edition_id)
      match_id = options.delete(:id)

      list = get(URLS[:list], query: { editionid: edition_id.to_i }) if edition_id
      list = get(URLS[:single], query: { matchid: match_id.to_i }) if match_id

      list
    end

    def initialize(hash)
      #hash = JSON.parse(JSON_TEST)
      @id = hash['n_MatchID']
      @date = Formatter.format_date(hash['d_DateUTC'])
      @rescheduled = hash['b_RescheduledToBeResumed']
      @round = hash['round']

      @referee = Referee.new(hash)
      @phase = Phase.new(hash)

      @home_team = Team.new(hash, 'home')
      @away_team = Team.new(hash, 'away')

      @goals = Goals.new(hash)
    end
  end

  #class Phase
  #  attr_accessor :id, :level, :name, :short_name
#
  #  def initialize(hash)
  #    @id = hash['n_PhaseID']
  #    @level = hash['n_PhaseLevel']
  #    @name = hash['c_Phase']
  #    @short_name = hash['c_PhaseShort']
  #  end
  #end

  class Goals
    attr_accessor :home_goals, :away_goals, :home_goals_half_time, :away_goals_half_time,
      :home_goals_90_mins, :away_goals_90_mins, :home_goals_105_mins, :away_goals_150_mins,
      :home_goals_shootout, :away_goals_shootout

    def initialize(hash)
      @home_goals = hash['n_HomeGoals']
      @away_goals = hash['n_AwayGoals']
      @home_goals_half_time = hash['n_HomeGoalsHalftime']
      @away_goals_half_time = hash['n_AwayGoalsHalftime']
      @home_goals_90_mins = hash['n_HomeGoals90mins']
      @away_goals_90_mins = hash['n_AwayGoals90mins']
      @home_goals_105_mins = hash['n_HomeGoals105mins']
      @away_goals_105_mins = hash['n_AwayGoals105mins']
      @home_goals_shootout = hash['n_HomeGoalsShootout']
      @away_goald_shootout = hash['n_AwayGoalsShootout']
    end
  end
end