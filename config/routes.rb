require 'sidekiq/web'

Rails.application.routes.draw do

  mount Bulkrax::Engine, at: '/'
  concern :oai_provider, BlacklightOaiProvider::Routes.new

  mount BrowseEverything::Engine => '/browse'

  devise_for :users

  get '/admin/workflows(.:format)', to: 'admin/workflows#index'

  resources :collections, only: [:index, :show] do # public landing show page
    member do
      get 'page/:page', action: :index
      get 'facet/:id', action: :facet, as: :dashboard_facet
      get :files
    end
  end

  # Override Collection edit form to use our collections controller
  get '/dashboard/collections/:id/edit(.:format)', to: 'ucsc/dashboard/collections#edit'
  mount Hyrax::Engine => '/'

  root 'hyrax/homepage#index'
  root :to => 'hyrax/homepage#index'

  resources :welcome, only: 'index'

  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  mount Qa::Engine => '/authorities'

  mount SamveraHls::Engine => '/'
  mount BulkOps::Engine => '/'

  get '/works/:id/zip_media_citation/media_citation.zip', to: 'hyrax/works#zip_media_citation'
  get '/works/:id/zip_media_citation/:size/media_citation.zip', to: 'hyrax/works#zip_media_citation'
  get '/concern/works/:id/zip_media_citation/media_citation.zip', to: 'hyrax/works#zip_media_citation'
  get '/concern/works/:id/zip_media_citation/:size/media_citation.zip', to: 'hyrax/works#zip_media_citation'
  get '/works/:id/zip_media_citation', to: 'hyrax/works#zip_media_citation'
  get '/works/:id/zip_media_citation/:size', to: 'hyrax/works#zip_media_citation'
  get '/concern/works/:id/zip_media_citation', to: 'hyrax/works#zip_media_citation'
  get '/concern/works/:id/:size/zip_media_citation', to: 'hyrax/works#zip_media_citation'

  post 'concern/works/:id/email' => 'hyrax/works#send_email'
  get 'concern/works/:id/email' => 'hyrax/works#show'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :oai_provider

    concerns :searchable
  end

  mount Hydra::RoleManagement::Engine => '/'

  get '/records/:id' => 'records#show'
  get '/authorize/:id' => 'ucsc/authorization#authorize'

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
