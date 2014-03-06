module Infostrada
  # This class is used to format types that come from infostrada like dates.
  class Formatter
    # Formats the stupid date format from Infostrada.
    def self.format_date(date)
      if date && match = date.match(/\/Date\(([0-9]+)([\+\-])([0-9]+)\)\//i)
        # The date was in miliseconds since Unix epoch
        stamp = match[1].to_i / 1000

        offset = match[3].scan(/.{2}/)
        offset = offset[0].to_i * 3600 + offset[1].to_i

        final = stamp.send(match[2], offset)

        Time.at(final).to_date
      else
        Time.now.to_date
      end
    end
  end
end