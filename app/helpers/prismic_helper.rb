module PrismicHelper

  def prismic_render_text(content)
    @document["landing.#{content}"]&.as_text if @document["landing.#{content}"]
  end

  def prismic_render_html_text(content)
    @document["landing.#{content}"]&.as_text.html_safe if @document["landing.#{content}"]
  end

  def prismic_render_url(name)
    @document["landing.#{name}"]&.url if @document["landing.#{name}"]
  end

  def link_resolver()
    @link_resolver ||= Prismic::LinkResolver.new(nil) { |link|

      # URL for the category type
      if link.type == "category"
        "/category/" + link.uid

      # URL for the product type
      elsif link.type == "product"
        "/product/" + link.id

      # Default case for all other types
      else
        "/"
      end
    }
  end

  def prismic_render_link(field)
    @document["landing.#{field}"]&.url(link_resolver) if @document["landing.#{field}"]
  end

  def prismic_render_link_label(field)
    if @document["landing.#{field}"]
      link_label = @document["landing.#{field}"].url
      link_label.split('https://')[1]
    end
  end
end
