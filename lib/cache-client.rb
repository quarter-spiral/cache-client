module Cache
  class Client
  end
end

require "cache-client/version"
require "cache-client/error"
require "cache-client/utils"
require "cache-client/key_builder"
require "cache-backend/noop_backend"

module Cache
  class Client
    attr_reader :backend
    def initialize(backend, *args)
      @backend = backendify(backend).new(*args)
    end

    def set(key, value)
      @backend.set(keyify(key), value)
    end

    def get(key)
      @backend.get(keyify(key))
    end

    def fetch(key)
      existing_value = get(key)
      return existing_value if existing_value
      set(key, yield)
    end

    protected
    def backendify(backend)
      return Cache::Backend::NoopBackend unless backend

      return backend if backend.kind_of?(Class)

      clazz = Class
      Utils.camelize_string(backend).split('::').each do |const|
        clazz = clazz.const_get(const)
      end
      clazz
    end

    def keyify(keys)
      Array(keys).map {|key| KeyBuilder.new(key)}.join('-')
    end
  end
end