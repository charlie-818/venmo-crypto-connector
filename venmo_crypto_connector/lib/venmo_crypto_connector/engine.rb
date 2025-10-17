module VenmoCryptoConnector
  class Engine < ::Rails::Engine
    isolate_namespace VenmoCryptoConnector

    # Engine configuration
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    # Load engine migrations
    initializer "venmo_crypto_connector.load_migrations" do |app|
      config.paths["db/migrate"].expanded.each do |expanded_path|
        app.config.paths["db/migrate"] << expanded_path
      end
    end

    # Engine routes
    initializer "venmo_crypto_connector.routes" do
      VenmoCryptoConnector::Engine.routes.draw do
        namespace :api do
          namespace :v1 do
            resources :nonces, only: [:show]
            resources :wallet_connections, only: [:create, :index, :show, :destroy]
            post 'verify_signature', to: 'authentications#verify'
            resources :users, only: [:show, :update] do
              member do
                get :stats
              end
            end
          end
        end

        # Traditional routes for educational content
        root to: 'dashboard#index'
        resources :tutorials, only: [:index, :show]
        resources :modules, only: [:show] do
          member do
            post :complete
          end
        end
        resources :venmo_guides, only: [:show] do
          member do
            post :complete
          end
        end
        resources :simulated_transactions, only: [:create, :index, :show]
        resources :simulated_wallets, only: [:show] do
          member do
            post :transfer
            post :purchase
          end
        end
        get 'dashboard', to: 'dashboard#index'
        get 'onboarding', to: 'onboarding#index'
      end
    end
  end
end
