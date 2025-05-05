# frozen_string_literal: true

class PresenceService
  REDIS_KEY = 'online_users'

  def self.mark_online(user_id)
    RedisConnection.client.hset(REDIS_KEY, user_id, Time.now.to_i)
  end

  def self.mark_offline(user_id)
    RedisConnection.client.hdel(REDIS_KEY, user_id)
  end

  def self.online?(user_id)
    RedisConnection.client.hexists(REDIS_KEY, user_id)
  end

  def self.online_users
    RedisConnection.client.hkeys(REDIS_KEY)
  end
end
