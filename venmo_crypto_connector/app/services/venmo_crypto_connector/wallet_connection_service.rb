module VenmoCryptoConnector
  class WalletConnectionService < BaseService
    def initialize(user, wallet_address, signature, message)
      @user = user
      @wallet_address = wallet_address.downcase
      @signature = signature
      @message = message
    end

    def call
      return failure_result('Invalid wallet address format') unless valid_address?
      return failure_result('Signature verification failed') unless verify_signature

      wallet_connection = create_wallet_connection
      update_user_progress

      success_result(wallet_connection: wallet_connection)
    rescue StandardError => e
      log_error("Wallet connection failed", e)
      failure_result('Wallet connection failed due to server error')
    end

    private

    def valid_address?
      @wallet_address.match?(/\A0x[a-fA-F0-9]{40}\z/)
    end

    def verify_signature
      siwe_message = Siwe::Message.from_message(@message)
      siwe_message.verify(@signature, @wallet_address, domain: ENV['APP_DOMAIN'] || 'localhost')
    rescue StandardError => e
      log_error("Signature verification error: #{e.message}", e)
      false
    end

    def create_wallet_connection
      wallet_connection = @user.wallet_connections.find_or_initialize_by(address: @wallet_address)
      wallet_connection.verified_at = Time.current
      wallet_connection.save!
      wallet_connection
    end

    def update_user_progress
      @user.update!(
        eth_address: @wallet_address,
        wallet_connected: true
      )
      
      if @user.onboarding_step == 'not_started'
        @user.advance_onboarding_step!
      end
    end
  end
end
