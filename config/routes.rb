Goodbrews::Application.routes.draw do
  root :to => 'dashboard#index', :constraints => lambda { |request| request.cookies['auth_token'] }
  root :to => 'pages#welcome'

  resource :account, :controller => :account, :except => :show do
    collection do
      get  :sign_in, :controller  => :authentication, :action => :new, :as => :sign_in
      post :sign_in, :controller  => :authentication, :action => :create
      post :sign_out, :controller => :authentication, :action => :destroy, :as => :sign_out

      get  :ignored
    end
  end

  resource :dashboard, :controller => :dashboard, :only => :index do
    collection do
      get '' => :index, :as => '' # Cool story, Rails
      get :recommendations
      get :likes
      get :dislikes
      get :fridge
      get :similar
    end
  end

  resources :beers, :only => [] do
    member do
      post   :like
      delete :like,    :action => :unlike,    :as => :unlike
      post   :dislike
      delete :dislike, :action => :undislike, :as => :undislike
      post   :ignore
      delete :ignore,  :action => :unignore,  :as => :unignore
      post   :stash
      delete :stash,   :action => :unstash,   :as => :unstash
    end
  end

  resources :breweries, :only => :show

  resources :users, :only => :show do
    member do
      get :recommendations
      get :likes
      get :dislikes
      get :fridge
      get :similar
    end
  end

  post :search, :controller => :searches, :action => :search, :as => :search

  controller :pages do
    get :welcome
    get :about
    get :privacy
    get :terms
  end
end
