Rails.application.routes.draw do
  root "imports#new"

  resources :imports, only: [:new, :create, :show, :edit, :destroy, :update] do
    member do
      # post :confirm
      get :new_property
      post :create_property

    end
    
    resources :units, only: [:new, :create, :destroy]
    # resources :units, only: [:new, :create, :edit, :update, :destroy]
  end

end
