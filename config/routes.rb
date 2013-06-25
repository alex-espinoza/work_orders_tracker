WorkOrdersTracker::Application.routes.draw do
  root :to => "teams#index"

  devise_for :users, :controllers => { :registrations => "registrations" }

  devise_scope :user do
    get "users/sign_up/:invitation_token", :to => "registrations#new_with_token", :as => :new_user_token_registration
  end

  resources :teams do
    resources :orders
    resources :team_invitations, :only => [:new, :create]
  end

  resources :orders do
    resources :order_responses
  end

  resources :users
end
