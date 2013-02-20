require_relative './spec_helper'

require 'digest/sha1'

class ObectWithToCacheKey
  def initialize(arg)
    @arg = arg
  end

  def to_cache_key
    "_#{@arg}_#{@arg}_"
  end
end

class ObectWithoutToCacheKey
  def initialize(arg)
    @arg = arg
  end
end

class TestingBackend
  attr_reader :last_key

  def get(key)
    @last_key = key
    nil
  end
end

describe Cache::Client do
  describe "cache keys" do
    before do
      @client = Cache::Client.new(TestingBackend)
    end

    it "uses #to_cache_key method when available" do
      key = ObectWithToCacheKey.new('bla')
      @client.get(key)
      @client.backend.last_key.must_equal(key.to_cache_key())
    end

    it "uses the key itself if it is a string" do
      @client.get('bla')
      @client.backend.last_key.must_equal('bla')
    end

    it "uses a string version of the key if it is a number" do
      @client.get(10)
      @client.backend.last_key.must_equal('10')

      @client.get(7.3)
      @client.backend.last_key.must_equal('7.3')
    end

    it "uses a SHA1 of the marshalled key when #to_cache_key is not available and the key is neither a string nor a number" do
      key = ObectWithoutToCacheKey.new('bla')
      @client.get(key)
      expected_key = Digest::SHA1.hexdigest(Marshal.dump(key))

      @client.backend.last_key.must_equal(expected_key)
    end

    it "concatenates built keys for arrays of keys" do
      key1 = ObectWithToCacheKey.new('bla')
      key2 = ObectWithoutToCacheKey.new('bla')
      key3 = 'yeah'
      key4 = 65.7

      @client.get([key1, key2, key3, key4])
      expected_key = "#{key1.to_cache_key}-#{Digest::SHA1.hexdigest(Marshal.dump(key2))}-#{key3}-#{key4}"
      @client.backend.last_key.must_equal(expected_key)
    end
  end
end