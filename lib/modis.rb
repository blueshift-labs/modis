require 'redis'
require 'rediscluster'
require 'connection_pool'
require 'active_model'
require 'active_support/all'
require 'yaml'
require 'msgpack'

require 'modis/version'
require 'modis/configuration'
require 'modis/attribute'
require 'modis/errors'
require 'modis/persistence'
require 'modis/transaction'
require 'modis/finder'
require 'modis/index'
require 'modis/model'

module Modis
  @mutex = Mutex.new

  class << self
    attr_accessor :connection_pool, :redis_options, :connection_pool_size,
                  :connection_pool_timeout, :cluster_connection
  end

  self.redis_options = { driver: :hiredis }
  self.connection_pool_size = 5
  self.connection_pool_timeout = 5

  def self.cluster_mode?
    redis_options[:cluster].present?
  end

  def self.connection_pool
    return @connection_pool if @connection_pool
    @mutex.synchronize do
      options = { size: connection_pool_size, timeout: connection_pool_timeout }
      @connection_pool = ConnectionPool.new(options) { Redis.new(redis_options) }
    end
  end

  # Our redis cluster client already uses a connection pool
  def self.cluster_connection
    return @cluster_connection if @cluster_connection
    @mutex.synchronize do
      max_cached_connections = redis_options[:max_cached_connections] || redis_options[:nodes].size
      @cluster_connection = RedisCluster.new(redis_options[:nodes], max_cached_connections)
    end
  end

  def self.with_connection
    if cluster_mode?
      yield(cluster_connection)
    else
      connection_pool.with { |connection| yield(connection) }
    end
  end
end
