
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
