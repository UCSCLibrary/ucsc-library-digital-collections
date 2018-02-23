require 'sidekiq/web'

Rails.application.routes.draw do
  concern :oai_provider, BlacklightOaiProvider::Routes.new

  mount BrowseEverything::Engine => '/browse'

  devise_for :users

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


end
