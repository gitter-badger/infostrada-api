module Infostrada
  # n_CompetitionSet is an indicator for the type of Competition:
  #
  # 1 = domestic league
  # 2 = domestic cup
  # 3 = international club competition (e.g. Champions League)
  # 4 = country competition (e.g. World Cup)
  #
  # n_CompetitionLevel is an indicator for the level of a domestic competition:
  #
  # 1 = highest level (e.g. German Bundesliga)
  # 2 = 2nd highest level (e.g. German 2. Bundesliga)
  # 3 = 3rd highest level and so on
  class Competition
    attr_accessor :id, :name, :set, :level, :nation

    def initialize(hash)
      @id = hash.delete('n_CompetitionID')
      @name = hash.delete('c_Competition')

      @nation = Nation.new(hash, 'competition')
    end
  end
end