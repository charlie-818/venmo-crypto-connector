#!/usr/bin/env ruby

# Venmo Crypto Connector Installation Script
# This script helps set up the engine in a host Rails application

require 'fileutils'
require 'yaml'

class VenmoCryptoConnectorInstaller
  def initialize
    @engine_path = File.expand_path(File.dirname(__FILE__))
    @host_app_path = nil
  end

  def run
    puts "🚀 Venmo Crypto Connector Installation"
    puts "=" * 50

    setup_host_application
    install_dependencies
    configure_routes
    setup_database
    seed_data
    setup_environment
    create_sample_files

    puts "\n✅ Installation complete!"
    puts "\nNext steps:"
    puts "1. Start your Rails server: rails server"
    puts "2. Visit: http://localhost:3000/crypto"
    puts "3. Connect your wallet to begin onboarding"
  end

  private

  def setup_host_application
    puts "\n📁 Setting up host application..."

    # Check if we're in a Rails app
    unless File.exist?('config/application.rb')
      puts "❌ This doesn't appear to be a Rails application."
      puts "Please run this script from your Rails app root directory."
      exit 1
    end

    @host_app_path = Dir.pwd
    puts "✅ Found Rails application at: #{@host_app_path}"
  end

  def install_dependencies
    puts "\n📦 Installing dependencies..."

    # Add gem to Gemfile
    gemfile_path = File.join(@host_app_path, 'Gemfile')
    gemfile_content = File.read(gemfile_path)

    unless gemfile_content.include?('venmo_crypto_connector')
      gem_entry = "\n# Venmo Crypto Connector Engine\ngem 'venmo_crypto_connector', path: '#{@engine_path}'\n"
      
      File.open(gemfile_path, 'a') do |f|
        f.write(gem_entry)
      end
      
      puts "✅ Added venmo_crypto_connector to Gemfile"
    else
      puts "✅ venmo_crypto_connector already in Gemfile"
    end

    # Run bundle install
    puts "Running bundle install..."
    system("cd #{@host_app_path} && bundle install")
  end

  def configure_routes
    puts "\n🛣️  Configuring routes..."

    routes_path = File.join(@host_app_path, 'config/routes.rb')
    routes_content = File.read(routes_path)

    unless routes_content.include?('mount VenmoCryptoConnector::Engine')
      mount_line = "\n  # Mount Venmo Crypto Connector Engine\n  mount VenmoCryptoConnector::Engine, at: '/crypto'\n"
      
      # Insert before the last 'end'
      routes_content.gsub!(/\nend\s*$/, "#{mount_line}\nend")
      
      File.write(routes_path, routes_content)
      puts "✅ Added engine mount to routes"
    else
      puts "✅ Engine already mounted in routes"
    end
  end

  def setup_database
    puts "\n🗄️  Setting up database..."

    # Copy migrations
    migrations_source = File.join(@engine_path, 'db/migrate')
    migrations_dest = File.join(@host_app_path, 'db/migrate')

    if Dir.exist?(migrations_source)
      Dir.glob(File.join(migrations_source, '*.rb')).each do |migration_file|
        filename = File.basename(migration_file)
        dest_file = File.join(migrations_dest, filename)
        
        unless File.exist?(dest_file)
          FileUtils.cp(migration_file, dest_file)
          puts "✅ Copied migration: #{filename}"
        end
      end
    end

    # Run migrations
    puts "Running database migrations..."
    system("cd #{@host_app_path} && rails db:migrate")
  end

  def seed_data
    puts "\n🌱 Seeding data..."

    # Copy and run seed file
    seed_file = File.join(@engine_path, 'db/seeds.rb')
    if File.exist?(seed_file)
      # Load the seed file in the context of the host app
      system("cd #{@host_app_path} && rails runner \"#{File.read(seed_file)}\"")
      puts "✅ Seeded educational modules and guides"
    end
  end

  def setup_environment
    puts "\n⚙️  Setting up environment..."

    env_file = File.join(@host_app_path, '.env')
    env_example = File.join(@engine_path, '.env.example')

    # Create .env.example if it doesn't exist
    unless File.exist?(env_example)
      File.write(env_example, <<~ENV)
        # Venmo Crypto Connector Environment Variables
        APP_DOMAIN=localhost:3000
        SECRET_KEY_BASE=your_secret_key_base_here
        
        # Optional: Enhanced features
        WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id
        INFURA_API_KEY=your_infura_api_key
        COINBASE_APP_ID=your_coinbase_app_id
        
        # Database
        DATABASE_URL=postgresql://username:password@localhost/your_app_development
      ENV
    end

    # Copy .env.example to .env if .env doesn't exist
    unless File.exist?(env_file)
      FileUtils.cp(env_example, env_file)
      puts "✅ Created .env file from template"
      puts "⚠️  Please update .env with your actual values"
    else
      puts "✅ .env file already exists"
    end
  end

  def create_sample_files
    puts "\n📄 Creating sample files..."

    # Create a sample controller to demonstrate usage
    sample_controller = File.join(@host_app_path, 'app/controllers/crypto_demo_controller.rb')
    unless File.exist?(sample_controller)
      File.write(sample_controller, <<~RUBY)
        class CryptoDemoController < ApplicationController
          def index
            # This controller demonstrates how to interact with the engine
            # You can access engine models like this:
            # @users = VenmoCryptoConnector::User.all
            # @modules = VenmoCryptoConnector::EducationModule.ordered
            
            redirect_to '/crypto'
          end
        end
      RUBY
      puts "✅ Created sample controller"
    end

    # Create a sample view
    views_dir = File.join(@host_app_path, 'app/views/crypto_demo')
    FileUtils.mkdir_p(views_dir) unless Dir.exist?(views_dir)
    
    sample_view = File.join(views_dir, 'index.html.erb')
    unless File.exist?(sample_view)
      File.write(sample_view, <<~ERB)
        <h1>Crypto Demo</h1>
        <p>This is a sample view demonstrating the Venmo Crypto Connector engine.</p>
        <p><%= link_to 'Go to Crypto Onboarding', '/crypto', class: 'btn btn-primary' %></p>
      ERB
      puts "✅ Created sample view"
    end
  end
end

# Run the installer
if __FILE__ == $0
  installer = VenmoCryptoConnectorInstaller.new
  installer.run
end
