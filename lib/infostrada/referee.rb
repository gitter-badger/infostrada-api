module Infostrada
  class Referee
    attr_accessor :id, :name, :nation

    def initialize(hash)
      @id = hash.delete('n_RefereeID')

      @name = hash.delete('c_Referee')

      @nation = Nation.new(hash, 'referee')
    end
  end
end