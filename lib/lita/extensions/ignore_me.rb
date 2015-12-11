module Lita::Extensions

  class IgnoreMe
    extend Lita::IgnoreRegistry

    def self.call(payload)
      message = payload.fetch(:message)
      message.command? or not ignored? message.source
    end

    Lita.register_hook(:validate_route, IgnoreMe)
  end

end
