module Infostrada
  class Competition
    attr_accessor :id, :name, :set, :level, :nation

    def initialize(hash)
      @id = hash.delete('n_CompetitionID')
      @name = hash.delete('c_Competition')

      @nation = Nation.new
      set_nation_attributes(hash)
    end

    private

    def set_nation_attributes(hash)
      hash.each do |key, value|
        if key =~ /[cn]_\w+Natio.*/
          method = "#{key.snake_case.gsub(/[cn]_competition_?/, '')}="
          @nation.send(method, value)
        end
      end
    end
  end
end