require 'resque/server'
Rails.application.routes.draw do
  mount BrowseEverything::Engine => '/browse'

  devise_for :users

  mount Sufia::Engine => '/'

  root 'sufia/homepage#index'
  root :to => 'sufia/homepage#index'

  mount CurationConcerns::Engine, at: '/'
  resources :welcome, only: 'index'

  curation_concerns_collections
  curation_concerns_basic_routes
  curation_concerns_embargo_management
  concern :exportable, Blacklight::Routes::Exportable.new


  mount HydraHls::Engine => '/'

  Hydra::BatchEdit.add_routes(self)
  mount Qa::Engine => '/authorities'

  # Administrative URLs
  namespace :admin do
    # Job monitoring
    constraints ResqueAdmin do
      mount Resque::Server, at: 'queues'
    end
  end
  
  mount Blacklight::Engine => '/'
  
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  mount Hydra::RoleManagement::Engine => '/'

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resources :bmi_rows do
    member do
      get :row_info
    end
  end
  resources :bmi_ingests do
    member do
      get :row_info
      get :info
      get :ingest_all
      post :process_row
      get :export_csv
#      get :pending
#      get :ingesting
#      get :completed
    end
  end
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
