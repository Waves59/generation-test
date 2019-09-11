
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
