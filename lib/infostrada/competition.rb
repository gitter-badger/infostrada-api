module Infostrada
  class Competition
    attr_accessor :id, :name, :set, :level, :nation

    def initialize(hash)
      @id = hash.delete('n_CompetitionID')
      @name = hash.delete('c_Competition')

      @nation = Nation.new(hash, 'competition')
    end
  end
end