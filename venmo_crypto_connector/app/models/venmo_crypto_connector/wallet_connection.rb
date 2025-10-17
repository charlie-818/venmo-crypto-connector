module VenmoCryptoConnector
  class WalletConnection < ApplicationRecord
    self.table_name = 'venmo_crypto_connector_wallet_connections'

    belongs_to :user

    validates :address, presence: true, uniqueness: { scope: :user_id }
    validates :address, format: { with: /\A0x[a-fA-F0-9]{40}\z/, message: 'must be a valid Ethereum address' }

    scope :verified, -> { where.not(verified_at: nil) }
    scope :primary, -> { where(primary: true) }

    def verified?
      verified_at.present?
    end

    def formatted_address
      "#{address[0..5]}...#{address[-4..-1]}"
    end

    def short_address
      address[0..9] + '...'
    end

    def make_primary!
      # Remove primary status from other wallets
      user.wallet_connections.where.not(id: id).update_all(primary: false)
      update!(primary: true)
    end
  end
end
