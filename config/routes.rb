Rails.application.routes.draw do
  root "imports#new"

  resources :imports, only: [:new, :create, :show, :edit, :destroy, :update] do
    member do
      post :confirm
    end
  end

end
