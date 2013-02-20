require_relative './spec_helper'

describe Cache::Client do
  describe "without a cache class" do
    before do
      @client = Cache::Client.new(nil)
    end

    it "does not cache anything" do
      @client.set('bla', 123).must_equal(123)
      @client.get('bla').must_be_nil
      @client.fetch('bla') do
        456
      end.must_equal 456
    end
  end

  describe "backends" do
    it "can be set using a class as a backend descriptor" do
      client = Cache::Client.new(Cache::InMemoryBackend)
      client.backend.kind_of?(Cache::InMemoryBackend).must_equal true
    end

    it "can be set using a class name string as a backend descriptor" do
      client = Cache::Client.new('Cache::InMemoryBackend')
      client.backend.kind_of?(Cache::InMemoryBackend).must_equal true
    end

    it "passes a list of options through to the backend" do
      class ArgumentTestBackend
        attr_reader :args
        def initialize(*args)
          @args = args
        end
      end

      client = Cache::Client.new(ArgumentTestBackend, 1, 2, 3, {'four' => :five})
      client.backend.args.must_equal([1, 2, 3, {'four' => :five}])
    end

    describe "that are initialized" do
      before do
        @client = Cache::Client.new(Cache::InMemoryBackend)
      end

      it "can set/get values" do
        @client.set('bla', 123).must_equal(123)
        @client.get('bla').must_equal(123)
      end

      it "can fetch values" do
        @client.fetch(['bla', 'fetch']) do
          123
        end.must_equal(123)

        @client.fetch(['bla', 'fetch']) do
          456
        end.must_equal(123)

        @client.get(['bla', 'fetch']).must_equal(123)
      end
    end
  end
end