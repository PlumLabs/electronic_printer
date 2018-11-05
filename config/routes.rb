Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json } do
    scope module: :v1 do
      resources :documents
    end
  end
end
