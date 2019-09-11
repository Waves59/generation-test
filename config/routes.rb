Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  localized do
    root to: 'pages#index', as: 'index'
    get '/legal_notice', to: 'pages#legal_notice', as: 'legal_notice'
    get '/privacy_policy', to: 'pages#privacy_policy', as: 'privacy_policy'
    get '/terms_service', to: 'pages#terms_service', as: 'terms_service'

  end
end
