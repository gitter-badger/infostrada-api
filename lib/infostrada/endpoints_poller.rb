require 'eventmachine'

require 'infostrada/base_request'
require 'infostrada/call_refresh'

module Infostrada
  # This is the base class that you should subclass to make a new endpoints poller. You should also
  # call the EndpointsPoller.set_frequency and EndpointsPoller.listen_to and define a
  # process_endpoints(endpoints) that will be called when there are updates on the list of endpoints
  # defined via listen_to. EndpointsPoller will use CallRefresh behind the scenes to fetch the
  # updated endpoints.
  #
  # Example of a minimal poller:
  #
  # module Infostrada
  #   class GamesPoller < EndpointsPoller
  #     # What's the request frequency, in seconds.
  #     set_frequency 15
  #
  #     # What are the endpoints that we're interested in?
  #     listen_to %w(GetMatchActionList_All)
  #
  #     def process_endpoints(endpoints)
  #     end
  #   end
  # end
  class EndpointsPoller
    class << self
      attr_accessor :polling_frequency, :endpoints

      # Called on the sublcasses to set what's the interval (in seconds) for the requests.
      def set_frequency(frequency)
        @polling_frequency = frequency
      end

      # Also called on the cubclasses to set what are the endpoints that we will parse.
      def listen_to(endpoints)
        @endpoints = endpoints
      end
    end

    # Main cycle that calls EM.run and will then use the EndpointsPoller#process_endpoints method
    # to process the updated endpoints.
    def run
      EM.run do
        EM.add_periodic_timer(self.class.polling_frequency) do
          puts "[#{Time.now}] Refresh since #{CallRefresh.last_update}"

          endpoints = EndpointChecker.new(self.class.endpoints)

          endpoints.callback { |endpoints| process_endpoints(endpoints) }
          endpoints.errback { |error| puts "ERROR: #{error}" }
        end
      end
    end

    def process_endpoints(endpoints)
      raise InfostradaError, 'You have to override process_endpoints method!'
    end
  end

  # EndpointChecker is an helper class that will call CallRefresh.get_latest to check which updates
  # were made since the last request. It will then call .succeed or .fail asynchronously.
  class EndpointChecker
    include EM::Deferrable

    def initialize(endpoints_whitelist)
      begin
        updated = Infostrada::CallRefresh.get_latest
        updated = updated.select { |endpoint| endpoints_whitelist.include?(endpoint.method) }

        self.succeed(updated)
      rescue => e
        self.fail(e.message)
      end
    end
  end
end