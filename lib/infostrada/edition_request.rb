module Infostrada
  class EditionRequest < Infostrada::BaseRequest
    URLS = {
      list: '/GetEditionList'
    }

    def self.get_list
      list = get!(URLS[:list])

      editions = []
      list.each do |edition_hash|
        editions << Edition.new(edition_hash)
      end

      editions
    end
  end
end