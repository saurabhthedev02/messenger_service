# frozen_string_literal: true

module RedisConnection
  class << self
    def client
      @client ||= Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/1')
    end
  end
end
