require 'sidekiq/web'

WorkOrdersTracker::Application.routes.draw do
  root :to => "teams#index"

  devise_for :users, :controllers => { :registrations => "registrations", :except => [:edit] }

  authenticate :user, lambda { |u| u.id == 1 } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_scope :user do
    get "users/sign_up/:invitation_token", :to => "registrations#new_with_token", :as => :new_user_token_registration
  end

  resources :teams, :except => [:edit, :update, :destroy] do
    resources :orders, :except => [:index, :destroy] do
      put "/reassign", :to => "orders#reassign", :as => :reassign
      put "/close", :to => "orders#close", :as => :close
      put "/complete", :to => "orders#complete", :as => :complete
    end
    resources :team_invitations, :only => [:new, :create]
  end

  resources :orders, :except => [:index, :new, :create, :edit, :show, :update, :destroy] do
    resources :order_responses, :only => [:create]
  end
end
