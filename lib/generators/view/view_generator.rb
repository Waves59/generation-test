class ViewGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def copy_controller_file
    case file_name
    when 'slim_install'
      copy_slim_views_file
    when 'header_footer_install'
      copy_header_footer_file
    when 'testimonials_install'
      copy_testimonials_file
    end
  end

  private

  def copy_slim_views_file
    remove_file 'app/views/layouts/application.html.erb'
    copy_file 'application.html.slim', 'app/views/layouts/application.html.slim'
  end

  def copy_header_footer_file
    copy_file 'header.html.slim', 'app/views/shared/_header.html.slim'
    copy_file 'footer.html.slim', 'app/views/shared/_footer.html.slim'
    inject_into_file 'app/views/layouts/application.html.slim', "    = render 'shared/header'\n", after: "  body\n"
    inject_into_file 'app/views/layouts/application.html.slim', "    = render 'shared/footer'\n", after: "    = yield\n"
  end

  def copy_testimonials_file
    copy_file 'testimonials.html.slim', 'app/views/sections/_testimonials.html.slim'
  end

end
