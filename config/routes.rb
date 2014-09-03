Upmin::Engine.routes.draw do
  root to: "models#dashboard"

  scope :models do
    # TODO(jon): Put dashboards elsewhere prob.. whatever for now.
    get "/", as: :upmin_dashboard, controller: :models, action: :dashboard

    scope "/:model_name" do
      match "/", as: :upmin_search, controller: :models, action: :search, via: [:get, :post]

      scope "/:id" do
        get "/", as: :upmin_model, controller: :models, action: :show
        put "/", controller: :models, action: :update

        post "/:method", as: :upmin_action, controller: :models, action: :action
      end
    end
  end
end
