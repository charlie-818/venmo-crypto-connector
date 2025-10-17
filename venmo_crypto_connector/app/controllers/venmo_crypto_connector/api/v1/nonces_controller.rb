module VenmoCryptoConnector
  module Api
    module V1
      class NoncesController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :validate_address

        def show
          user = User.find_or_initialize_by(eth_address: params[:address].downcase)
          user.eth_nonce ||= SecureRandom.uuid
          user.save if user.new_record?

          render json: { 
            nonce: user.eth_nonce,
            message: create_auth_message(user.eth_nonce)
          }
        end

        private

        def validate_address
          address = params[:address]
          unless address&.match?(/\A0x[a-fA-F0-9]{40}\z/)
            render json: { error: 'Invalid Ethereum address format' }, status: :bad_request
          end
        end

        def create_auth_message(nonce)
          "Sign in to Venmo Crypto Connector\n\n" +
          "This signature proves you control this wallet address.\n\n" +
          "Nonce: #{nonce}\n" +
          "Timestamp: #{Time.current.to_i}\n" +
          "Domain: #{request.host}"
        end
      end
    end
  end
end
