require 'sidekiq/web'

Rails.application.routes.draw do

  concern :oai_provider, BlacklightOaiProvider::Routes.new

  mount BrowseEverything::Engine => '/browse'

  devise_for :users

  get '/admin/workflows(.:format)', to: 'admin/workflows#index'

  mount Hyrax::Engine => '/'

  root 'hyrax/homepage#index'
  root :to => 'hyrax/homepage#index'

  resources :welcome, only: 'index'

  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  mount Qa::Engine => '/authorities'

  mount SamveraHls::Engine => '/'

  # Administrative URLs
  namespace :bulk_metadata do
    resources :edits do
      member do
        get :export
      end
    end
    resources :rows do
      member do
        get :row_info
      end
    end
    get "row_info/:row_id", to: "ingests#row_info", as: 'row_info'
    resources :ingests do
      member do
        get :info
        get :ingest_all
        post :process_row
        get :export_csv
        #      get :pending
        #      get :ingesting
        #      get :completed
      end
    end
  end

#  mount Sidekiq::Web => '/sidekiq' unless Rails.env.production?
  mount Sidekiq::Web => '/sidekiq' 

#  soon! so soon...
#  mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?
  
  mount Blacklight::Engine => '/'
  
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :oai_provider

    concerns :searchable
  end

  mount Hydra::RoleManagement::Engine => '/'

  get '/records/:id' => 'records#show'

  

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  put '/dashboard/workflow_actions/update(.:format)', to: 'admin/workflow_actions#update'
  patch '/dashboard/workflow_actions/update(.:format)', to: 'admin/workflow_actions#update'

  get '/github_auth/:user_id', to: "github_credentials#authenticate"
#  get '/works/:export_csv', to: "works#export_csv"

  get '/bulk_updates', to: "bulk_updates#index"
  get '/bulk_updates/new', to: "bulk_updates#new"
  post '/bulk_updates/new', to: "bulk_updates#new"
  get '/bulk_updates/show/:update_name', to: "bulk_updates#show"
  get '/bulk_updates/edit/:update_name', to: "bulk_updates#edit"
  post '/bulk_updates/edit/:update_name', to: "bulk_updates#edit"
  post '/bulk_updates/delete/:update_name', to: "bulk_updates#delete"
  post '/bulk_updates/apply/:update_name', to: "bulk_updates#apply"
  get '/bulk_updates/csv/:update_name', to: "bulk_updates#csv"
  get '/bulk_updates/preview/:update_name', to: "bulk_updates#preview"
  get '/bulk_updates/existing', to: "bulk_updates#export_csv"
  get '/bulk_updates/in_progress', to: "bulk_updates#running"
  get '/bulk_updates/errors', to: "bulk_updates#errors"
  get '/bulk_updates/log', to: "bulk_updates#log"
  get '/bulk_updates/status', to: "bulk_updates#status"
  get '/bulk_updates/completed', to: "bulk_updates#completed"
  
  
  
end
