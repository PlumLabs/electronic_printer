module Afip
  module Exceptions
    class InvalidForm < Exception; end
    class DestroyError < Exception; end
    class BravoAfipError < Exception; end
    class AlreadyInvoiced < Exception; end
  end
end
