module Infostrada
  class Edition < Infostrada::Base
    URLS = {
      list: '/GetEditionList'
    }

    class << self
      def list
        list = get(URLS[:list])
      end
    end
  end
end