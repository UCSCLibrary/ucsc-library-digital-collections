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
  mount BulkOps::Engine => '/'

  mount Sidekiq::Web => '/sidekiq' 

  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  
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

  put '/dashboard/workflow_actions/update(.:format)', to: 'admin/workflow_actions#update'
  patch '/dashboard/workflow_actions/update(.:format)', to: 'admin/workflow_actions#update'
    
end
