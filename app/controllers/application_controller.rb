class ApplicationController < ActionController::Base
  before_action :set_raven_context
  before_action :require_prismic

  private
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def i18n_api_query(predicate)
    lang = if I18n.locale == :fr then "fr-fr" else "en-us" end

    api.query(predicate,
      { lang: lang }
    )
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def api
    @api ||= PrismicService.init_api
  end

  def require_prismic
    response = i18n_api_query(
      Prismic::Predicates.at('document.type', 'landing')
    )
    @document = response.results.first
    raise "Missing data from Prismic response: #{response.inspect}" if @document.nil?
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
