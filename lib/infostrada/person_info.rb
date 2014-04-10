require 'infostrada/base_request'

module Infostrada
  class PersonInfo < Infostrada::BaseRequest
    URL = '/GetPersonInfo'

    attr_accessor :id, :first_name, :last_name, :public_name, :nickname, :height, :birthdate
    attr_accessor :weight, :birth_city, :birth_country

    def self.where(options)
      id = options.delete(:person_id)

      info = get!(URL, query: { personid: id }).first

      self.new(id, info)
    end

    def initialize(id, info)
      @id = id

      # Sometimes info comes as an empty array...
      if info && !info.empty?
        @first_name = info['c_FirstName']
        @last_name = info['c_LastName']
        @public_name = info['c_PublicName']
        @nickname = info['c_Nickname']
        @birthdate = Formatter.format_date(info['d_BirthDate'])
        @height = info['n_Height']
        @weight = info['n_Weight']
        @birth_city = info['c_BirthCity']
        @birth_country = info['c_BirthCountry']
      end
    end
  end
end