module Infostrada
  # This is the class that every class making API requests must descend from. It includes HTTParty
  # to easily support every type of HTTP request. The basic_auth is set up from the
  # Infostrada.configuration mechanism described in the Infostrada module.
  class BaseRequest
    include HTTParty

    # How many times should we retry the request if Timeout::Error is raised?
    RETRIES = 5

    # Uncomment to debug HTTParty calls.
    # debug_output $stdout

    # TODO: can we delete this dummy values?
    basic_auth 'USERNAME', 'PASSWORD'
    base_uri = 'demo.api.infostradasports.com/svc/Football.svc/json/'

    # The default format of the requests. Used on HTTP header 'Content-Type'.
    format :json

    # Which default parameters we can send in every request?
    #
    # languageCode can be one of the following:
    # 1 = dutch
    # 2 = english
    # 4 = french
    # 8 = german
    # 128 = norwegian
    # 256 = swedish
    # 1024 = danish
    default_params languageCode: 2

    # Default request timeout in seconds. This can be overriden by module configuration.
    default_timeout 15

    # Disable the use of rails query string format.
    #
    # With rails query string format enabled:
    #   => get '/', :query => { selected_ids: [1,2,3] }
    #
    # Would translate to this:
    #   => /?selected_ids[]=1&selected_ids[]=2&selected_ids[]=3
    #
    disable_rails_query_string_format

    # Used with Timeout::Error rescue so we can keep trying to fetch the information after timeout.
    def self.get!(path, options = {}, &block)
      attempts = 1
      result = nil

      begin
        result = get(path, options, &block)
      rescue Timeout::Error => e
        puts "Timeout! Retrying... (#{attempts})"
        attempts += 1
        if attempts > RETRIES
          raise Infostrada::RequestError.new, 'Request timeout'
        else
          retry
        end
      end

      result
    end
  end
end