require 'infostrada/referee'
require 'infostrada/match_event_list'

module Infostrada
  # You can get the information about a single game, about all games in an edition or about all
  # games in a day.
  #
  # Examples:
  #
  #  Infostrada::Match.where(edition_id: 2398)        # all matches for edition 2398
  #  Infostrada::Match.where(date: Time.now)          # all matches for current date (live info)
  #  Infostrada::Match.where(date: Date.today+1.day)  # all matches for tomorrow (live info)
  #  Infostrada::Match.where(id: 1337)                # information about the match 1337
  class Match < Infostrada::BaseRequest
    extend Forwardable

    attr_accessor :id, :date, :rescheduled, :round, :home_team, :away_team, :phase, :status_short
    attr_accessor :stadium_id, :stadium_name, :goals, :match_status, :finished, :awarded
    attr_accessor :postponed, :referee, :spectators, :leg, :knockout_phase, :first_leg_score
    attr_accessor :aggregate_winner_id, :current_period_started_at, :status, :started_at, :started
    attr_accessor :edition, :time_unknown, :date_unknown

    # Check if the live score, live goals and live lineups are already available
    attr_accessor :live, :live_score, :live_goals, :live_lineup

    # Lineup
    attr_accessor :lineup_provisional, :lineup_official

    # period is taken from Infostradas n_PeriodSort, that can have one of these values:
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
    attr_accessor :period

    # status_code is taken from Infostradas n_MatchStatusCode, that can have on of these values:
    #
    # 2 = Line-up
    # 4 = Not Started
    # 8 = In Progress
    # 16 = Interval
    # 32 = Suspended (during the match)
    # 128 = Finished (official result)
    # 192 = Finished (unofficial result). This is a combination of code 64 and 128.
    # 512 = Abandoned
    # 1024 = Postponed
    # 2048 = Delayed
    #
    # If a match is stopped temporarily, n_MatchStatusCode is set to 32 (=Suspended).
    # If it becomes clear that the match, after being suspended, will not be restarted on the same
    # day, n_MatchStatusCode is set to 512 (=Abandoned).
    attr_accessor :status_code

    def_delegator :@phase, :id, :phase_id
    def_delegator :@referee, :name, :referee_name
    def_delegator :@goals, :away_goals, :away_goals
    def_delegator :@goals, :home_goals, :home_goals
    def_delegator :@edition, :id, :edition_id
    def_delegator :@home_team, :id, :home_team_id
    def_delegator :@away_team, :id, :away_team_id

    # We can get all matches for a given edition (very heavy payload). Or we can just get the match
    # information on a single match.
    URLS = {
      list: '/GetMatchList_Edition',
      single: '/GetMatchInfo',
      live_list: '/GetMatchLiveList_Date'
    }

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
      date = options.delete(:date)
      date = date.strftime('%Y%m%d') if date

      list = get!(URLS[:list], query: { editionid: edition_id.to_i }) if edition_id
      list = get!(URLS[:single], query: { matchid: match_id.to_i }) if match_id
      list = get!(URLS[:live_list], query: { date: date }) if date

      list
    end

    def initialize(hash)
      @id = hash['n_MatchID']
      @date = Formatter.format_date(hash['d_DateUTC'])
      @rescheduled = hash['b_RescheduledToBeResumed']
      @round = hash['n_RoundNr']
      @time_unknown = hash['b_TimeUnknown']
      @date_unknown = hash['b_DateUnknown']

      @aggregate_winner_id = hash['n_WinnerOnAggregateTeamID']
      @current_period_started_at = Formatter.format_date(hash['d_CurrentPeriodStartTime'])
      @status_code = hash['n_MatchStatusCode']
      @status = hash['c_MatchStatus']
      @status_short = hash['c_MatchStatusShort']
      @leg = hash['n_Leg']
      @started_at = Formatter.format_date(hash['d_MatchStartTime'])

      @stadium_id = hash['n_StadiumGeoID']
      @stadium_name = hash['c_Stadium']
      @spectators = hash['n_Spectators']
      @city = hash['c_City']

      @live = hash['b_Live']
      @started = hash['b_Started']
      @finished = hash['b_Finished']
      @awarded = hash['b_Awarded']

      @live_score = hash['b_DataEntryLiveScore']
      @live_goals = hash['b_DataEntryLiveGoal']
      @live_lineup = hash['b_DataEntryLiveLineup']

      @lineup_provisional = hash['b_LineupProvisional']
      @lineup_official = hash['b_LineupOfficial']

      @period = hash['n_PeriodSort']

      @referee = Referee.new(hash)
      @phase = Phase.new(hash)

      @home_team = Team.new(hash, 'home')
      @away_team = Team.new(hash, 'away')

      @goals = Goals.new(hash)

      @edition = Edition.new(hash)

      self
    end

    def live_score?
      @live_score || false
    end

    def live_goals?
      @live_goals || false
    end

    def live_lineup?
      @live_lineup || false
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