require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'admin/events#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/sidekiq'
  post '/github_event_handler', to: 'webhook#handle'
  resources :projects, only: [] do
    resource :metrics, only: [] do
      get 'review_turnaround', controller: :projects
    end
  end
end
