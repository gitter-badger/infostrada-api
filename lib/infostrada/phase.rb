module Infostrada
  # Phase of a given edition.
  #
  # The only thing that can be confusing is the current and currents boolean variables. Here's an
  # explanation from the Infostrada API website:
  #
  #  * b_Current: this boolean field describes the current phase. This field can be True for only
  #               one phase.
  #
  #  * b_Currents: this boolean field describes the current phases. More than one phases can be
  #                True, e.g. multiple groups in the Champions League.
  #
  # You can only get a list of phases on Infostradas GetPhaseList endpoint.
  class Phase < Infostrada::BaseRequest
    URL = '/GetPhaseList'

    # Short name is only set outside GetPhaseList endpoint. For example on match list.
    attr_accessor :id, :name, :phase1_id, :phase1_name, :phase2_id, :phase2_name, :phase3_id
    attr_accessor :phase3_name, :table, :current, :currents, :start_date, :end_date, :short_name

    def self.where(options = {})
      edition_id = options.delete(:edition_id)

      list = get!(URL, query: { editionid: edition_id.to_i })

      phases = []
      list.each do |phase_hash|
        phases << Phase.new(phase_hash)
      end

      phases
    end

    # Get the classification table for this phase.
    def table
      Table.where(phase_id: id)
    end

    def initialize(hash)
      @id = hash['n_PhaseID']
      @name = hash['c_Phase']
      @short_name = hash['c_PhaseShort']
      @phase1_id = hash['n_Phase1ID']
      @phase1_name = hash['c_Phase1']
      @phase2_id = hash['n_Phase2ID']
      @phase2_name = hash['c_Phase2']
      @phase3_id = hash['n_Phase3ID']
      @phase3_name = hash['c_Phase3']
      @has_table = hash['b_Table']
      @current = hash['b_Current']
      @currents = hash['b_Currents']

      # On GetPhaseList endpoint dates are just yyymmdd. Example: 20100629 (which translates to
      # 2010-06-29).
      if hash['n_DateStart'] && hash['n_DateEnd']
        @start_date = Date.parse(hash['n_DateStart'].to_s)
        @end_date = Date.parse(hash['n_DateEnd'].to_s)
      end

      self
    end

    def has_table?
      @has_table
    end
  end
end