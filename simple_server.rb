#!/usr/bin/env ruby

# Simple HTTP server to demonstrate the Venmo Crypto Connector
# This provides a basic web interface without requiring full Rails setup

require 'webrick'
require 'json'

class VenmoCryptoConnectorDemo
  def initialize
    @server = WEBrick::HTTPServer.new(Port: 3000)
    setup_routes
  end

  def start
    puts "🚀 Venmo Crypto Connector Demo Server"
    puts "=" * 50
    puts "Server starting on http://localhost:3000"
    puts "Press Ctrl+C to stop"
    puts "=" * 50
    
    trap 'INT' do
      puts "\n🛑 Shutting down server..."
      @server.shutdown
    end
    
    @server.start
  end

  private

  def setup_routes
    # Serve static files
    @server.mount('/', WEBrick::HTTPServlet::FileHandler, File.expand_path('.'))
    
    # API endpoints for demo
    @server.mount_proc('/api/v1/demo/nonces') do |req, res|
      res['Content-Type'] = 'application/json'
      res['Access-Control-Allow-Origin'] = '*'
      
      if req.request_method == 'GET'
        nonce = SecureRandom.uuid
        message = create_auth_message(nonce)
        
        res.body = {
          nonce: nonce,
          message: message,
          demo: true
        }.to_json
      else
        res.status = 405
        res.body = { error: 'Method not allowed' }.to_json
      end
    end

    @server.mount_proc('/api/v1/demo/verify') do |req, res|
      res['Content-Type'] = 'application/json'
      res['Access-Control-Allow-Origin'] = '*'
      
      if req.request_method == 'POST'
        # Simulate signature verification
        sleep(1) # Simulate processing time
        
        res.body = {
          success: true,
          user: {
            id: 1,
            eth_address: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
            onboarding_step: 'wallet_connected',
            experience_points: 150
          },
          session_token: 'demo_token_' + SecureRandom.hex(16),
          demo: true
        }.to_json
      else
        res.status = 405
        res.body = { error: 'Method not allowed' }.to_json
      end
    end

    @server.mount_proc('/api/v1/demo/modules') do |req, res|
      res['Content-Type'] = 'application/json'
      res['Access-Control-Allow-Origin'] = '*'
      
      modules = [
        {
          id: 1,
          title: "Crypto Basics for Venmo Users",
          description: "Learn the fundamentals of cryptocurrency and how it relates to your Venmo experience.",
          sequence_number: 1,
          module_type: "video",
          estimated_duration_minutes: 5,
          completed: false
        },
        {
          id: 2,
          title: "Setting Up Your Venmo for Crypto",
          description: "Step-by-step guide to enabling crypto features in your Venmo account.",
          sequence_number: 2,
          module_type: "interactive",
          estimated_duration_minutes: 8,
          completed: false
        },
        {
          id: 3,
          title: "Your First Crypto Purchase",
          description: "Learn how to buy cryptocurrency through Venmo with confidence.",
          sequence_number: 3,
          module_type: "video",
          estimated_duration_minutes: 6,
          completed: true
        }
      ]
      
      res.body = {
        success: true,
        modules: modules,
        demo: true
      }.to_json
    end

    @server.mount_proc('/api/v1/demo/wallet') do |req, res|
      res['Content-Type'] = 'application/json'
      res['Access-Control-Allow-Origin'] = '*'
      
      wallet_data = {
        usdc_balance: 100.0,
        ethereum_balance: 0.05,
        bitcoin_balance: 0.001,
        pyusd_balance: 50.0,
        total_value_usd: 250.0
      }
      
      res.body = {
        success: true,
        wallet: wallet_data,
        demo: true
      }.to_json
    end
  end

  def create_auth_message(nonce)
    "Sign in to Venmo Crypto Connector Demo\n\n" +
    "This signature proves you control this wallet address.\n\n" +
    "Nonce: #{nonce}\n" +
    "Timestamp: #{Time.now.to_i}\n" +
    "Domain: localhost:3000"
  end
end

# Start the demo server
if __FILE__ == $0
  require 'securerandom'
  demo = VenmoCryptoConnectorDemo.new
  demo.start
end
