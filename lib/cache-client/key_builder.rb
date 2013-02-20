require 'digest/sha1'

class Cache::Client
  class KeyBuilder
    def initialize(key)
      @key = key
    end

    def to_s
      return @key.to_cache_key if @key.respond_to?(:to_cache_key)

      return @key if @key.kind_of?(String)
      return @key.to_s if @key.kind_of?(Numeric)

      return Digest::SHA1.hexdigest(Marshal.dump(@key))
    end
  end
end