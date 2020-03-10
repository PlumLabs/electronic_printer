Rails.application.routes.draw do
  # Api definition
  namespace :api do
    namespace :v1 do
      namespace :billings do
        get :bill, :collection
        get :state, :member
        get :send_data, :member
      end
    end
  end
end
