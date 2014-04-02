require 'infostrada/referee'
require 'infostrada/match_event_list'

module Infostrada
  class Match < Infostrada::BaseRequest
    extend Forwardable

    attr_accessor :id, :date, :rescheduled, :round, :home_team, :away_team, :phase, :status_short
    attr_accessor :stadium_id, :stadium_name, :goals, :match_status, :finished, :awarded
    attr_accessor :postponed, :referee, :spectators, :leg, :knockout_phase, :first_leg_score
    attr_accessor :aggregate_winner_id, :current_period_started_at, :status, :started_at, :started
    attr_accessor :competition

    # Check if the live score, live goals and live lineups are already available
    attr_accessor :live, :live_score, :live_goals, :live_lineup

    # Lineup
    attr_accessor :lineup_provisional, :lineup_official

    def_delegator :@referee, :name, :referee_name
    def_delegator :@phase, :name, :phase_name
    def_delegator :@goals, :away_goals, :away_goals
    def_delegator :@goals, :home_goals, :home_goals

    # We can get all matches for a given edition (very heavy payload). Or we can just get the match
    # information on a single match.
    URLS = {
      list: '/GetMatchList_Edition',
      single: '/GetMatchInfo'
    }

    def self.where(options = {})
      list = get_match_list(options)

      matches = []
      list.each do |match_hash|
        matches << Match.new(match_hash)
      end

      matches.size > 1 ? matches : matches.first
    end

    def self.get_match_list(options)
      edition_id = options.delete(:edition_id)
      match_id = options.delete(:id)

      list = get!(URLS[:list], query: { editionid: edition_id.to_i }) if edition_id
      list = get!(URLS[:single], query: { matchid: match_id.to_i }) if match_id

      list
    end

    def initialize(hash)
      @id = hash['n_MatchID']
      @date = Formatter.format_date(hash['d_DateUTC'])
      @rescheduled = hash['b_RescheduledToBeResumed']
      @round = hash['round']

      @aggregate_winner_id = hash['n_WinnerOnAggregateTeamID']
      @current_period_started_at = Formatter.format_date(hash['d_CurrentPeriodStartTime'])
      @status = hash['c_MatchStatus']
      @status_short = hash['c_MatchStatusShort']
      @leg = hash['n_Leg']
      @started_at = Formatter.format_date(hash['d_MatchStartTime'])

      @stadium_id = hash['n_StadiumGeoID']
      @stadium_name = hash['c_Stadium']

      @live = hash['b_Live']
      @started = hash['b_Started']
      @finished = hash['b_Finished']
      @awarded = hash['b_Awarded']

      @live = hash['b_Live']
      @live_score = hash['b_DataEntryLiveScore']
      @live_goals = hash['b_DataEntryLiveGoal']
      @live_lineup = hash['b_DataEntryLiveLineup']

      @lineup_provisional = hash['b_LineupProvisional']
      @lineup_official = hash['b_LineupOfficial']

      @referee = Referee.new(hash)
      @phase = Phase.new(hash)

      @home_team = Team.new(hash, 'home')
      @away_team = Team.new(hash, 'away')

      @goals = Goals.new(hash)

      @competition = Competition.new(hash)

      self
    end

    def live_event_list
      event_list = MatchEventList.where(match_id: self.id)
    end
  end

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