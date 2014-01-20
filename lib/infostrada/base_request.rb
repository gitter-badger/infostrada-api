module Infostrada
  class BaseRequest
    include HTTParty

    # Uncomment to debug HTTParty calls.
    # debug_output $stdout

    # The default format of the requests. Used on HTTP header 'Content-Type'.
    format :json

    # Base URI of the service. Since the gem is only football related for now we can have the
    # football path already in the base_uri.
    base_uri 'demo.api.infostradasports.com/svc/Football.svc/json/'

    # TODO: these should be configurable
    # The authentication is made using basic_auth.
    basic_auth 'APIdemo', 'Sauv@k@vel4'

    # Which default parameters we can send in every request?
    default_params languageCode: 2

    # Default request timeout in seconds.
    default_timeout 10

    # Disable the use of rails query string format.
    #
    # With rails query string format enabled:
    #   => get '/', :query => {:selected_ids => [1,2,3]}
    #
    # Would translate to this:
    #   => /?selected_ids[]=1&selected_ids[]=2&selected_ids[]=3
    #
    disable_rails_query_string_format
  end
end