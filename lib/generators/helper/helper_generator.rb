class HelperGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def copy_helper_file
    case file_name
    when 'prismic_helper'
      copy_prismic_helper_file
    end
  end

  private

  def copy_prismic_helper_file
    copy_file 'prismic_helper.rb', "app/helpers/#{file_name}.rb"
  end
end
