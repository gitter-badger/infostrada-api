module Infostrada
  class Team
    extend Forwardable

    def_delegator :@nation, :id, :nation_id
    def_delegator :@nation, :name, :nation_name
    def_delegator :@nation, :short_name, :nation_short_name

    attr_accessor :id, :name, :short_name, :nation, :edition_id

    def self.all(edition_id)
      teams = TeamRequest.get_edition(edition_id.to_i)
    end

    def initialize(hash, prefix)
      @edition_id = hash['edition_id']

      hash.each do |key, value|
        case key.snake_case
        when /^[cn]\w+#{prefix}_team_id$/
          self.send('team_id=', value)
        when /^[cn]\w+#{prefix}_team$/
          self.send('team_name=', value)
        when /^[cn]\w+#{prefix}_team_short$/
          self.send('team_short=', value)
        end
      end

      @nation = Nation.new(hash, "#{prefix}_team")
    end

    def team_id=(id)
      @id = id
    end

    def team_name=(name)
      @name = name
    end

    def team_short=(short_name)
      @short_name = short_name
    end

    def details
      info ||= TeamInfo.fetch(self)
    end
  end
end