module Infostrada
  class BaseError < StandardError
  end

  class InvalidParameter < BaseError
  end

  class RequestError < BaseError
  end

  class InfostradaError < BaseError
  end
end