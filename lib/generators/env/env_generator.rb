class EnvGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def copy_env_file
    case file_name
    when 'set_env'
      set_env
    when 'prismic_env'
      copy_prismic_env
    when 'env_heroku'
      copy_env_heroku
    when 'env_mailjet'
      set_mailjet_env
    when 'env_sentry'
      set_sentry_env
    when 'env_git'
      set_git_env
    when 'env_tools'
      set_tools_env
    when 'routes_i18n'
      set_routes_i18n
    end
  end

  private

  def set_env
    copy_file '.env', '.env'
    copy_file '.env.example', '.env.example'
  end

  def set_tools_env
    copy_file '.tool-versions', '.tool-versions'
  end

  def copy_prismic_env
    env = IO.read('lib/generators/env/templates/prismic_env')
    inject_into_file '.env', env, after: /# VAR ENV\n/
    inject_into_file '.env.example', env, after: /# VAR ENV\n/
    inject_into_file '.env', "\nHOST=\n", after: /# VAR ENV\n/
    inject_into_file '.env.example', "\nHOST=\n", after: /# VAR ENV\n/
    inject_into_file 'app.json', "    \"HOST\": { \"required\": true },\n", after: "\"env\": {\n"
    inject_into_file 'app.json', "    \"PRISMIC_API_URL\": { \"required\": true },\n", after: "\"env\": {\n"
    inject_into_file 'app.json', "    \"PRISMIC_API_TOKEN\": { \"required\": true },\n", after: "\"env\": {\n"
    gsub_file 'app.json', ",\n  },", "\n  },"
  end

  def copy_env_heroku
    copy_file 'app.json', 'app.json'
    copy_file 'Procfile', 'Procfile'
    name = Rails.application.class.parent.to_s.underscore.sub('_', '-')
    gsub_file 'app.json', "\"name\": \"\"", "\"name\": \"#{name}\""
  end

  def set_mailjet_env
    dev = IO.read('lib/generators/env/templates/mailjet_development.rb')
    inject_into_file 'config/environments/development.rb', dev, before: /^end/
    prod = IO.read('lib/generators/env/templates/mailjet_production.rb')
    inject_into_file 'config/environments/production.rb', prod, before: /^end/
    env = IO.read('lib/generators/env/templates/mailjet_env')
    inject_into_file '.env', env, after: /# VAR ENV\n/
    env_example = IO.read('lib/generators/env/templates/mailjet_env_example')
    inject_into_file '.env.example', env_example, after: /# VAR ENV\n/
    inject_into_file 'app.json', "    \"MAILJET_SECRET_KEY\": { \"required\": true },\n", after: "\"env\": {\n"
    inject_into_file 'app.json', "    \"MAILJET_API_KEY\": { \"required\": true },\n", after: "\"env\": {\n"
    gsub_file 'app.json', ",\n  },", "\n  },"
  end

  def set_sentry_env
    env = IO.read('lib/generators/env/templates/sentry_env')
    inject_into_file '.env', env, after: /# VAR ENV\n/
    inject_into_file '.env.example', env, after: /# VAR ENV\n/
    inject_into_file 'app.json', "    \"SENTRY_DSN\": { \"required\": true },\n", after: "\"env\": {\n"
    gsub_file 'app.json', ",\n  },", "\n  },"
  end

  def set_git_env
    remove_file '.gitignore'
    copy_file '.gitignore', '.gitignore'

    remove_file 'README.md'
    copy_file 'README.md', 'README.md'
  end

  def set_routes_i18n
    inject_into_file 'config/routes.rb', "  localized do\n", before: /^end/
    inject_into_file 'config/routes.rb', "\n  end\n", before: /^end/
  end
end
