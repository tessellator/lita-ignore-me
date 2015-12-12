module Lita
  module Handlers

    class IgnoreMe < Handler
      include IgnoreRegistry

      route(/^ignore me$/i, :ignore_me, command: true, help: {
        "ignore me" => t('ignore_help')
      })

      route(/^listen to me$/i, :listen_to_me, command: true, help: {
        "listen to me" => t('listen_help')
      })

      def ignore_me(response)
        source = response.message.source
        name = source.user.name
        room = source.room_object.name

        if ignored? source
          response.reply t('already_ignored', name: name, room: room)
        else
          ignore source
          response.reply t('ignored', name: name, room: room)
        end
      end

      def listen_to_me(response)
        source = response.message.source
        name = source.user.name

        if ignored? source
          heed source
          response.reply t('listening', name: name)
        else
          response.reply t('already_listening', name: name)
        end
      end

    end

    Lita.register_handler(IgnoreMe)
  end
end
