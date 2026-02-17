Rails.application.routes.draw do
  root "imports#new"

  resources :imports, only: [:new, :create, :show, :edit, :destroy, :update] do
    member do
      post :confirm
      get :show_final
      get :new_property
      post :create_property
    end
    
    resources :units, only: [:new, :create, :destroy]
  end

  resources :properties, only: [:index] do
    collection do
      delete :destroy_all
      get :export
    end
  end
end
