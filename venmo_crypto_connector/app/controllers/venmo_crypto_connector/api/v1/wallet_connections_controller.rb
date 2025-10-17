module VenmoCryptoConnector
  module Api
    module V1
      class WalletConnectionsController < ApplicationController
        before_action :validate_params

        def create
          result = WalletConnectionService.call(
            current_user,
            params[:address],
            params[:signature],
            params[:message]
          )

          if result.success?
            render json: {
              success: true,
              wallet_connection: {
                id: result.data[:wallet_connection].id,
                address: result.data[:wallet_connection].address,
                verified_at: result.data[:wallet_connection].verified_at
              }
            }
          else
            render json: {
              success: false,
              errors: result.errors
            }, status: :unprocessable_entity
          end
        end

        def index
          wallet_connections = current_user.wallet_connections.verified
          
          render json: {
            success: true,
            wallet_connections: wallet_connections.map do |wc|
              {
                id: wc.id,
                address: wc.address,
                formatted_address: wc.formatted_address,
                verified_at: wc.verified_at,
                primary: wc.primary
              }
            end
          }
        end

        def show
          wallet_connection = current_user.wallet_connections.find(params[:id])
          
          # Get blockchain data
          blockchain_service = BlockchainService.new
          balance_result = blockchain_service.get_balance(wallet_connection.address)
          history_result = blockchain_service.get_transaction_history(wallet_connection.address, 5)

          render json: {
            success: true,
            wallet_connection: {
              id: wallet_connection.id,
              address: wallet_connection.address,
              formatted_address: wallet_connection.formatted_address,
              verified_at: wallet_connection.verified_at,
              primary: wallet_connection.primary
            },
            balance: balance_result.success? ? balance_result.data : nil,
            recent_transactions: history_result.success? ? history_result.data[:transactions] : []
          }
        end

        def destroy
          wallet_connection = current_user.wallet_connections.find(params[:id])
          wallet_connection.destroy!

          render json: { success: true }
        end

        private

        def validate_params
          if action_name == 'create'
            required_params = [:address, :signature, :message]
            missing_params = required_params.select { |param| params[param].blank? }
            
            if missing_params.any?
              render json: {
                success: false,
                errors: ["Missing required parameters: #{missing_params.join(', ')}"]
              }, status: :bad_request
            end
          end
        end
      end
    end
  end
end
