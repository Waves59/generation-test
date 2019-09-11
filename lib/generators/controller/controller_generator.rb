class ControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def copy_controller_file
    case file_name
    when 'pages_controller'
      copy_pages_controller_file
    when 'prismic_controller'
      copy_prismic_app_controller
    when 'i18n_controller'
      copy_i18n_methods
    when 'sentry_controller'
      set_sentry
    end
  end

  private

  def copy_pages_controller_file
    copy_file 'pages_controller.rb', "app/controllers/#{file_name}.rb"
    inject_into_file 'config/routes.rb', "    get '/terms_service', to: 'pages#terms_service', as: 'terms_service'\n", after: "  localized do\n"
    inject_into_file 'config/routes.rb', "    get '/privacy_policy', to: 'pages#privacy_policy', as: 'privacy_policy'\n", after: "  localized do\n"
    inject_into_file 'config/routes.rb', "    get '/legal_notice', to: 'pages#legal_notice', as: 'legal_notice'\n", after: "  localized do\n"
    inject_into_file 'config/routes.rb', "    root to: 'pages#index', as: 'index'\n", after: "  localized do\n"
    create_file 'app/views/pages/index.html.slim'
    create_file 'app/views/pages/legal_notice.html.slim'
    create_file 'app/views/pages/privacy_policy.html.slim'
    create_file 'app/views/pages/terms_service.html.slim'
    inject_into_file 'app/controllers/application_controller.rb', "\n  private\n", after: "class ApplicationController < ActionController::Base\n"
  end

  def copy_prismic_app_controller
    inject_into_file 'app/controllers/application_controller.rb', "  before_action :require_prismic\n", after: "class ApplicationController < ActionController::Base\n"
    methods = IO.read('lib/generators/controller/templates/prismic_methods.rb')
    inject_into_file 'app/controllers/application_controller.rb', methods, before: /^end/
  end

  def copy_i18n_methods
    inject_into_file 'app/controllers/application_controller.rb', "  before_action :set_locale\n", after: "class ApplicationController < ActionController::Base\n"
    methods = IO.read('lib/generators/controller/templates/i18n_methods.rb')
    inject_into_file 'app/controllers/application_controller.rb', methods, before: /^end/
  end

  def set_sentry
    inject_into_file 'app/controllers/application_controller.rb', "  before_action :set_raven_context\n", after: "class ApplicationController < ActionController::Base\n"
    methods = IO.read('lib/generators/controller/templates/sentry_methods.rb')
    inject_into_file 'app/controllers/application_controller.rb', methods, before: /^end/
  end
end
