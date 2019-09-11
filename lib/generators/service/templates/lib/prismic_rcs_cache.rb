require 'hashery'

module Prismic
  # Prismic Cache relying on Rails' Cache Store
  # Therefore, to use this cache, you can create your
  # API object like this:
  # ```
  # prismic_cache = Prismic::RailsCacheStoreCache.new(disable_expiration: true)
  #
  # Prismic.api(url,
  #             cache: prismic_cache,
  #             api_cache: prismic_cache,
  #             token: token)
  #```
  # disable_expiration will disable all expiration instructions given
  # by the prismic gem
  #
  class RailsCacheStoreCache
    def initialize(opts = {})
      @key_prefix = opts[:key_prefix] || 'Prismic::RailsCacheStoreCache'
      @disable_expiration = opts[:disable_expiration] == true
    end

    # Add a cache entry.
    #
    # @param key [String] The key
    # @param value [Object] The value to store
    #
    # @return [Object] The stored value
    def set(key, value, expires_in = nil)
      Rails.cache.fetch full_key(key), expires_in: correct_expiration(expires_in) do
        value
      end
    end

    def []=(key, value)
      Rails.cache.fetch full_key(key) do
        value
      end
    end

    # Get a cache entry
    #
    # @param key [String] The key to fetch
    #
    # @return [Object] The cache object as was stored
    def get(key)
      Rails.cache.fetch full_key(key)
    end
    alias :[] :get

    def get_or_set(key, value = nil, expires_in = nil)
      Rails.cache.fetch full_key(key), expires_in: correct_expiration(expires_in) do
        block_given? ? yield : value
      end
    end

    def delete(key)
      Rails.cache.delete full_key(key)
    end

    # Checks if a cache entry exists
    #
    # @param key [String] The key to test
    #
    # @return [Boolean]
    def has_key?(key)
      Rails.cache.exist? full_key(key)
    end
    alias :include? :has_key?


    # Invalidates all entries
    def invalidate_all!
      Rails.cache.delete_matched "#{@key_prefix}/*"
    end
    alias :clear! :invalidate_all!


    private

    def full_key(key)
      "#{@key_prefix}/#{key}"
    end

    def correct_expiration(expires_in)
      @disable_expiration ? nil : expires_in
    end
  end
end
