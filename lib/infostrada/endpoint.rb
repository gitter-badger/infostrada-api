module Infostrada
  class Endpoint
    attr_accessor :method, :last_modified, :query_string

    def initialize(hash)
      @method = hash['c_Method']
      @last_modified = Formatter.format_date(hash['d_LastModified'])
      @query_string = hash['c_QueryString']

      self
    end

    # Helper method to return the match id from the query string.
    def match_id
      @query_string.match(/matchid=(\d+)/)
      $1
    end

    # Helper method to return the phase id from the query string.
    def phase_id
      @query_string.match(/phaseid=(\d+)/)
      $1
    end
  end
end