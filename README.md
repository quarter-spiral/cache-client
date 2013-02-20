# Cache::Client

A client to store and retrieve data in a cache backend. The client is backend agnostic and can be used as a *noop-cache* without any backend.

## Usage

### Setup

To instantiate a new cache client you pass in a class of a cache backend and a list of parameters for that array. If either the backend class or all parameters are ``nil`` the cache will fall back to a noon mode. In that mode it will work without any errors but not cache anything at all. This is useful for tests and development mode.

```ruby
cache_client = Cache::Client.new(Cache::BackendClass, 'http://localhost', '8080')
```

Instead of an actual class instance you can also pass in a string of the backend's class name

```ruby
cache_client = Cache::Client.new('Cache::BackendClass', 'http://localhost', '8080')
```

### Cache keys

Cache keys can be any objects or arrays of objects. The ``Cache::Client`` will turn each object to a cache key using this methods in a top to bottom order:

* ``#to_cache_key``
* the key itself if it is a string
* the string version of the key if it is a number
* A SHA1 hash of the ``Marshal.dump`` of the key object

Objects in an array will each be turned into cache key first and then concatenated.

### Set a value in the cache

```ruby
cache_client.set(['my', 'key'], 123) # => 123
```

### Get a value from the cache

```ruby
cache_client.get(['my', 'key']) # => 123
```

### Set or get in the cache

This will set a value in the cache if the given key does not exist, otherwise it just returns the value under that key from the cache.

```ruby
cache_client.get(['my', 'key']) do
  123
end # => 123
```