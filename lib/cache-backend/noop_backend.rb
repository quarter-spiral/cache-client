module Cache
  module Backend
    class NoopBackend
      def initialize(*args)
      end

      def get(key)
      end

      def set(key, value)
        value
      end
    end
  end
end