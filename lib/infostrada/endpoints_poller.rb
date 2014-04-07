require 'eventmachine'

module Infostrada
  class EndpointsPoller
    class << self
      attr_accessor :polling_frequency, :endpoints

      def set_frequency(frequency)
        @polling_frequency = frequency
      end

      def listen_to(endpoints)
        @endpoints = endpoints
      end
    end

    def run
      EM.run {
        EM.add_periodic_timer(self.class.polling_frequency) do
          puts "[#{Time.now}] Refresh since #{CallRefresh.last_update}"

          endpoints = EndpointChecker.new
          endpoints.callback { |endpoints| process_endpoints(endpoints) }
          endpoints.errback { |error| puts "ERROR: #{error}" }
        end
      }
    end

    def process_endpoints(endpoints)
      raise InfostradaError, 'You have to override process_endpoints method!'
    end
  end

  class EndpointChecker
    include EM::Deferrable

    def initialize
      begin
        updated = Infostrada::CallRefresh.get_latest
        updated = updated.select { |endpoint| self.class.endpoints.include?(endpoint.method) }

        self.succeed(updated)
      rescue => e
        self.fail(e.message)
      end
    end
  end
end