module Infostrada
  class EndpointManager
    def self.register(hash)
      @endpoints ||= {}
      @endpoints.merge!(hash)
    end

    def self.list
      @endpoints
    end
  end
end