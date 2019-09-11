begin
  require 'prismic_rcs_cache.rb'
rescue LoadError
end

module PrismicService
  class << self
    ## Easier initialisation of the Prismic::API object.
    def init_api
      url = ENV['PRISMIC_API_URL']
      token = ENV['PRISMIC_API_TOKEN']

      prismic_api = if ENV['PRISMIC_DISABLE_CACHE'] != 'true'
        Prismic.api(
          url,
          access_token: token,
          api_cache: prismic_cache,
          cache: prismic_cache
        )
      else
        Prismic.api(url, access_token: token)
      end

      prismic_api
    end

    # Checks if the slug is the right one for the document.
    # You can change this depending on your URL strategy.
    def slug_checker(document, slug)
      if document.nil?
        { correct: false, redirect: false }
      elsif slug == document.slug
        { correct: true }
      elsif document.slugs.include?(slug)
        { correct: false, redirect: true }
      else
        { correct: false, redirect: false }
      end
    end

    def prismic_cache
      @prismic_cache ||= Prismic::RailsCacheStoreCache.new(disable_expiration: true)
    end
  end
end
