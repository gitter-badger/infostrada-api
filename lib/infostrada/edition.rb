require 'forwardable'

module Infostrada
  class Edition
    extend Forwardable

    attr_accessor :id, :competition, :season, :start_date, :end_date

    def_delegator :@competition, :name, :competition_name
    def_delegator :@competition, :id, :competition_id

    def self.all
      editions = EditionRequest.get_list
    end

    def initialize(hash)
      @id = hash.delete('n_EditionID')
      @season = hash.delete('c_Season')
      @start_date = Formatter.format_date(hash.delete('d_EditionStartDate'))
      @end_date = Formatter.format_date(hash.delete('d_EditionEndDate'))

      @competition = Competition.new(hash)
    end

    def teams
      Team.all(id)
    end
  end
end