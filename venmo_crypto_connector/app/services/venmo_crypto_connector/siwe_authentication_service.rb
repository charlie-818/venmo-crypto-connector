module VenmoCryptoConnector
  class SiweAuthenticationService < BaseService
    def initialize(message, signature, address)
      @message = message
      @signature = signature
      @address = address.downcase
    end

    def call
      return failure_result('Invalid message format') unless valid_message_format?
      return failure_result('Signature verification failed') unless verify_signature

      user = find_or_create_user
      rotate_nonce(user)

      session_token = user.create_session!
      success_result(user: user, session_token: session_token)
    rescue StandardError => e
      log_error("SIWE authentication failed", e)
      failure_result('Authentication failed due to server error')
    end

    private

    def valid_message_format?
      @message.match?(/Nonce: [a-f0-9-]+/i) && @message.match?(/Timestamp: \d+/)
    end

    def verify_signature
      siwe_message = Siwe::Message.from_message(@message)
      siwe_message.verify(@signature, @address, domain: ENV['APP_DOMAIN'] || 'localhost')
    rescue StandardError => e
      log_error("SIWE verification error: #{e.message}", e)
      false
    end

    def find_or_create_user
      user = User.find_or_initialize_by(eth_address: @address)
      if user.new_record?
        user.email = "#{@address}@crypto.local" # Temporary email
        user.username = "user_#{@address[0..7]}"
        user.eth_nonce = SecureRandom.uuid
        user.save!
      end
      user
    end

    def rotate_nonce(user)
      user.generate_new_nonce!
    end
  end
end
