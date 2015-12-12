module Lita
  module Handlers

    class IgnoreMe < Handler
      include IgnoreRegistry

      route(/^ignore me$/i, :ignore_me, command: true, help: {
        "ignore me" => t('ignore_help')
      })

      route(/^ignore me in (.+)$/i, :ignore_me_in_room, command: true, help: {
        "ignore me in #room" => t('ignore_help_with_room')
      })

      route(/^listen to me$/i, :listen_to_me, command: true, help: {
        "listen to me" => t('listen_help')
      })

      route(/^listen to me in (.+)$/i, :listen_to_me_in_room, command: true, help: {
        "listen to me in #room" => t('listen_help_with_room')
      })

      def find_room(response)
        Lita::Room.fuzzy_find(response.matches[0][0])
      end

      def ignore_me(response)
        ignore_source(response, response.message.source)
      end

      def ignore_me_in_room(response)
        room = find_room(response)
        user = response.message.source.user

        if room.nil?
          response.reply t('sorry_no_room', name: user.name)
        else
          source = Lita::Source.new(user: user, room: room)
          ignore_source(response, source)
        end
      end

      def ignore_source(response, source)
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
        listen_to_source(response, response.message.source)
      end

      def listen_to_me_in_room(response)
        room = find_room(response)
        user = response.message.source.user

        if room.nil?
          response.reply t('sorry_no_room', name: user.name)
        else
          source = Lita::Source.new(user: user, room: room)
          listen_to_source(response, source)
        end
      end

      def listen_to_source(response, source)
        name = source.user.name
        room = source.room_object.name

        if ignored? source
          heed source
          response.reply t('listening', name: name, room: room)
        else
          response.reply t('already_listening', name: name, room: room)
        end
      end

      private :find_room, :ignore_source, :listen_to_source

    end

    Lita.register_handler(IgnoreMe)
  end
end
