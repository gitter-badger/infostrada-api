module Infostrada
  class Endpoint
    attr_accessor :method, :last_modified, :query_string

    def initialize(hash)
      @method = hash['c_Method']
      @last_modified = Formatter.format_date(hash['d_LastModified'])
      @query_string = hash['c_QueryString']

      self
    end

    # Defines methods for parameter ids on the c_QueryString. These can be match_id, phase_id,
    # edition_id or team_id.
    %w(match phase edition team).each do |param|
      define_method("#{param}_id") do
        scan_id(param)
      end
    end

    private

    # Scans for the id of a given parameter in the c_QueryString. Returns the id for the parameter.
    #
    # Example
    #   => scan_id('edition') # will scan editionid number
    def scan_id(param)
      @query_string.match(/#{param}id=(\d+)/).captures.first
    end
  end
end