module VenmoCryptoConnector
  class SimulatedWallet < ApplicationRecord
    self.table_name = 'venmo_crypto_connector_simulated_wallets'

    belongs_to :user
    has_many :simulated_transactions, dependent: :destroy

    validates :usdc_balance, :ethereum_balance, :bitcoin_balance, :pyusd_balance,
              numericality: { greater_than_or_equal_to: 0 }

    def balance(cryptocurrency)
      case cryptocurrency.downcase
      when 'usdc'
        usdc_balance
      when 'ethereum', 'eth'
        ethereum_balance
      when 'bitcoin', 'btc'
        bitcoin_balance
      when 'pyusd'
        pyusd_balance
      else
        0
      end
    end

    def transfer_to(destination_address, amount, cryptocurrency)
      return { success: false, error: 'Insufficient balance' } if balance(cryptocurrency) < amount

      transaction = simulated_transactions.create!(
        transaction_type: 'send_external',
        cryptocurrency: cryptocurrency,
        amount: amount,
        destination_address: destination_address,
        status: 'pending'
      )

      # Simulate blockchain processing delay
      SimulateTransactionJob.perform_later(transaction.id)

      { success: true, transaction: transaction }
    end

    def purchase_crypto(amount_usd, cryptocurrency)
      # Simulate purchasing crypto with USD
      crypto_amount = calculate_crypto_amount(amount_usd, cryptocurrency)
      
      transaction = simulated_transactions.create!(
        transaction_type: 'purchase',
        cryptocurrency: cryptocurrency,
        amount: crypto_amount,
        status: 'pending'
      )

      # Simulate processing delay
      SimulateTransactionJob.perform_later(transaction.id)

      { success: true, transaction: transaction }
    end

    def receive_crypto(amount, cryptocurrency, from_address)
      transaction = simulated_transactions.create!(
        transaction_type: 'receive',
        cryptocurrency: cryptocurrency,
        amount: amount,
        destination_address: from_address,
        status: 'pending'
      )

      # Simulate processing delay
      SimulateTransactionJob.perform_later(transaction.id)

      { success: true, transaction: transaction }
    end

    def total_value_usd
      # Simplified USD values for simulation
      usdc_balance + 
      (ethereum_balance * 2000) + # ETH at $2000
      (bitcoin_balance * 45000) + # BTC at $45000
      pyusd_balance
    end

    private

    def calculate_crypto_amount(usd_amount, cryptocurrency)
      case cryptocurrency.downcase
      when 'usdc', 'pyusd'
        usd_amount
      when 'ethereum', 'eth'
        usd_amount / 2000.0 # ETH at $2000
      when 'bitcoin', 'btc'
        usd_amount / 45000.0 # BTC at $45000
      else
        usd_amount
      end
    end
  end
end
