module Lita
  module IgnoreRegistry

    def key(source)
      "ignore_me:#{source.room}"
    end

    def ignored?(source)
      Lita.redis.sismember(key(source), source.user.id)
    end

    def ignore(source)
      Lita.redis.sadd(key(source), source.user.id)
    end

    def heed(source)
      Lita.redis.srem(key(source), source.user.id)
    end

    private :key
  end
end
