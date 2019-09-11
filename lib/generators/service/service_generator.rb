class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def copy_service_file
    case file_name
    when 'prismic_service'
      copy_prismic_service_file
    when 'prismic_rcs_cache'
      copy_prismic_rcs_cache
    end
  end

  private

  def copy_prismic_service_file
    copy_file 'prismic_service.rb', 'app/services/prismic_service.rb'
  end

  def copy_prismic_rcs_cache
    directory 'lib', 'app/lib'
  end
end
