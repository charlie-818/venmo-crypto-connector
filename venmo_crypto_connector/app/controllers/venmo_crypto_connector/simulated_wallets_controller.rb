module VenmoCryptoConnector
  class SimulatedWalletsController < ApplicationController
    before_action :set_simulated_wallet

    def show
      @recent_transactions = @simulated_wallet.simulated_transactions.recent.limit(10)
    end

    def transfer
      result = @simulated_wallet.transfer_to(
        params[:destination_address],
        params[:amount].to_f,
        params[:cryptocurrency]
      )

      if result[:success]
        render json: {
          success: true,
          transaction: {
            id: result[:transaction].id,
            transaction_type: result[:transaction].transaction_type,
            cryptocurrency: result[:transaction].cryptocurrency,
            amount: result[:transaction].amount,
            status: result[:transaction].status
          }
        }
      else
        render json: {
          success: false,
          error: result[:error]
        }, status: :unprocessable_entity
      end
    end

    def purchase
      result = @simulated_wallet.purchase_crypto(
        params[:amount_usd].to_f,
        params[:cryptocurrency]
      )

      if result[:success]
        render json: {
          success: true,
          transaction: {
            id: result[:transaction].id,
            transaction_type: result[:transaction].transaction_type,
            cryptocurrency: result[:transaction].cryptocurrency,
            amount: result[:transaction].amount,
            status: result[:transaction].status
          }
        }
      else
        render json: {
          success: false,
          error: result[:error]
        }, status: :unprocessable_entity
      end
    end

    private

    def set_simulated_wallet
      @simulated_wallet = current_user.simulated_wallet
      unless @simulated_wallet
        render json: { error: 'Simulated wallet not found' }, status: :not_found
      end
    end
  end
end
