Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # root path
  root 'processes#index'

  # processes
  get '/processes', to: 'processes#index'
  get '/processes/:pid', to: 'processes#show'

  # linux_core
  get '/linux_core_data', to: 'linux_core#show'

  # files
  get '/files/:path', to: 'files#show', constraint: { path: /.*/ }
end
