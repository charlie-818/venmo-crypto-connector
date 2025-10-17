module VenmoCryptoConnector
  class SimulatedTransaction < ApplicationRecord
    self.table_name = 'venmo_crypto_connector_simulated_transactions'

    belongs_to :user
    belongs_to :simulated_wallet

    validates :transaction_type, inclusion: { in: %w[purchase send_internal send_external receive] }
    validates :cryptocurrency, presence: true
    validates :amount, numericality: { greater_than: 0 }
    validates :status, inclusion: { in: %w[pending confirmed failed] }

    scope :recent, -> { order(created_at: :desc) }
    scope :confirmed, -> { where(status: 'confirmed') }
    scope :pending, -> { where(status: 'pending') }
    scope :failed, -> { where(status: 'failed') }

    def confirmed?
      status == 'confirmed'
    end

    def pending?
      status == 'pending'
    end

    def failed?
      status == 'failed'
    end

    def processing_time
      return nil unless confirmed_at
      (confirmed_at - created_at).to_i
    end

    def formatted_amount
      case cryptocurrency.downcase
      when 'usdc', 'pyusd'
        "$#{amount.to_f.round(2)}"
      when 'ethereum', 'eth'
        "#{amount.to_f.round(6)} ETH"
      when 'bitcoin', 'btc'
        "#{amount.to_f.round(8)} BTC"
      else
        "#{amount} #{cryptocurrency.upcase}"
      end
    end

    def status_icon
      case status
      when 'confirmed'
        '✅'
      when 'pending'
        '⏳'
      when 'failed'
        '❌'
      end
    end

    def status_color
      case status
      when 'confirmed'
        'text-green-600'
      when 'pending'
        'text-yellow-600'
      when 'failed'
        'text-red-600'
      end
    end
  end
end
