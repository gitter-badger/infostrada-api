require 'pstore'
require 'tzinfo'
require 'infostrada/endpoint'

module Infostrada
  class CallRefresh < Infostrada::BaseRequest
    URL = '/GetAPICallRefresh_Module'

    # The API timezone. This is very important since all the dates passed as argument to the refresh
    # call must be in the correct timezone.
    TIMEZONE = 'Europe/Amsterdam'

    # Which languages are you interested in? The GetAPICallRefresh_Module call can return multiple
    # endpoints for the same thing if multiple languages are available.
    #
    # languageCode can be one of the following:
    # 1 = dutch
    # 2 = english
    # 4 = french
    # 8 = german
    # 128 = norwegian
    # 256 = swedish
    # 1024 = danish
    LANGUAGE_CODES = [2]

    # The outputType parameter can be one of the following:
    # 1 = xml
    # 2 = json
    # 3 = soap
    OUTPUT_TYPE = 2

    # How to format the date. This string will be used on a Date#strftime. Infostrada will work with
    # formats like this: 2013-09-21T22:22:22.
    DATE_FORMAT = '%FT%T'

    def self.store
      @store ||= PStore.new(Infostrada.configuration.last_update_file)
    end

    def self.last_update
      store.transaction { store[:last_update] }
    end

    def self.last_update=(date)
      store.transaction {
        store[:last_update] = date
        store.commit
      }
    end

    def self.api_time(date)
      @timezone ||= TZInfo::Timezone.get(TIMEZONE)
      @timezone.utc_to_local(date.utc)
    end

    def self.get_latest
      since(last_update || api_time(Time.now))
    end

    def self.since(date)
      self.last_update = api_time(Time.now)

      date_str = date.strftime(DATE_FORMAT)

      list = get!(URL, query: { from: date_str, outputType: OUTPUT_TYPE, module: 'football' })

      list.each_with_object([]) do |hash, endpoints|
        lang = hash['c_QueryString'].scan(/languagecode=(\d+)/).flatten.first.to_i
        endpoints << Endpoint.new(hash) if LANGUAGE_CODES.include?(lang)
      end
    end
  end
end