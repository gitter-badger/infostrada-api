module Infostrada
  class Team
    attr_accessor :id, :name, :short_name, :nation, :edition_id

    def self.all(edition_id)
      teams = TeamRequest.get_edition(edition_id.to_i)
    end

    def initialize(hash)
      @id = hash.delete('n_TeamID')
      @name = hash.delete('c_Team')
      @short_name = hash.delete('c_TeamShort')
      @edition_id = hash.delete('edition_id')

      @nation = Nation.new
      set_nation_attributes(hash)
    end

    def details
      info ||= TeamInfo.fetch(self)
    end

    private

    def set_nation_attributes(hash)
      hash.each do |key, value|
        if key =~ /[cn]_\w+Natio.*/
          method = "#{key.snake_case.gsub(/[cn]_team_?/, '')}="
          @nation.send(method, value)
        end
      end
    end
  end
end