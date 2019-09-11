class StylesheetGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def copy_controller_file
    case file_name
    when 'base_stylesheet'
      copy_base_stylesheet_file
    when 'templates_stylesheet'
      copy_template_scss
    end
  end

  private

  def copy_base_stylesheet_file
    remove_file 'app/assets/stylesheets/application.css'
    copy_file 'application.scss', 'app/assets/stylesheets/application.scss'
  end

  def copy_template_scss
    directory 'base', 'app/assets/stylesheets/base'
    directory 'components', 'app/assets/stylesheets/components'
    directory 'mixins', 'app/assets/stylesheets/mixins'
    directory 'utilities', 'app/assets/stylesheets/utilities'
  end

end
