
    Raven.configure do |config|
      config.dsn = ENV['SENTRY_DSN'] if Rails.env.production?
    end
