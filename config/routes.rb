Upmin::Engine.routes.draw do
  root to: "models#search"

  scope :models do
    get "/", as: :upmin_models, controller: :models, action: :list

    scope "/:model_name" do
      get "/", as: :upmin_model, controller: :models, action: :show
      get "/updated_since", as: :upmin_updated_since, controller: :models, action: :updated_since
    end
  end
  # resources :models, only: [:show, :index] do
  #   get :updated_since
  # end

end
