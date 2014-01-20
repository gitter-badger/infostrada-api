module Infostrada
  class Nation
    attr_accessor :id, :name, :short_name

    def natio_geo_id=(id)
      self.id = id
    end

    def natio=(name)
      self.name = name
    end

    def natio_short=(short_name)
      self.short_name = short_name
    end
  end
end