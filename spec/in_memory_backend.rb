module Cache
  class InMemoryBackend
    def initialize(*args)
      @store = {}
    end

    def get(key)
      @store[key]
    end

    def set(key, value)
      @store[key] = value
    end
  end
end