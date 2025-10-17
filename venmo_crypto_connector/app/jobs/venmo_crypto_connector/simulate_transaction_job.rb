module VenmoCryptoConnector
  class SimulateTransactionJob < ApplicationJob
    queue_as :default

    def perform(transaction_id)
      transaction = SimulatedTransaction.find(transaction_id)
      
      # Simulate realistic delay (3-8 seconds)
      sleep(rand(3..8))
      
      # 95% success rate for simulation
      if rand < 0.95
        transaction.update!(
          status: 'confirmed',
          confirmed_at: Time.current,
          transaction_hash: generate_fake_tx_hash
        )
        
        # Update wallet balances
        update_simulated_balances(transaction)
        
        # Award XP for successful simulation
        transaction.user.increment!(:experience_points, 50)
      else
        transaction.update!(
          status: 'failed',
          error_message: 'Simulated network congestion - please try again'
        )
      end
    rescue StandardError => e
      Rails.logger.error("SimulateTransactionJob failed: #{e.message}")
      transaction&.update!(
        status: 'failed',
        error_message: 'Simulation error occurred'
      )
    end

    private

    def generate_fake_tx_hash
      "0x" + SecureRandom.hex(32)
    end

    def update_simulated_balances(transaction)
      wallet = transaction.simulated_wallet
      crypto = transaction.cryptocurrency.downcase
      
      case transaction.transaction_type
      when 'purchase', 'receive'
        increment_balance(wallet, crypto, transaction.amount)
      when 'send_external', 'send_internal'
        decrement_balance(wallet, crypto, transaction.amount)
      end
    end

    def increment_balance(wallet, crypto, amount)
      case crypto
      when 'usdc'
        wallet.increment!(:usdc_balance, amount)
      when 'ethereum', 'eth'
        wallet.increment!(:ethereum_balance, amount)
      when 'bitcoin', 'btc'
        wallet.increment!(:bitcoin_balance, amount)
      when 'pyusd'
        wallet.increment!(:pyusd_balance, amount)
      end
    end

    def decrement_balance(wallet, crypto, amount)
      case crypto
      when 'usdc'
        wallet.decrement!(:usdc_balance, amount)
      when 'ethereum', 'eth'
        wallet.decrement!(:ethereum_balance, amount)
      when 'bitcoin', 'btc'
        wallet.decrement!(:bitcoin_balance, amount)
      when 'pyusd'
        wallet.decrement!(:pyusd_balance, amount)
      end
    end
  end
end
