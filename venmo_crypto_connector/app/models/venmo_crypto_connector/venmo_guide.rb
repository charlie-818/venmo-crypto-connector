module VenmoCryptoConnector
  class VenmoGuide < ApplicationRecord
    self.table_name = 'venmo_crypto_connector_venmo_guides'

    has_many :venmo_guide_steps, dependent: :destroy
    has_many :venmo_guide_progresses, dependent: :destroy
    has_many :users, through: :venmo_guide_progresses

    validates :title, :action, presence: true
    validates :action, uniqueness: true

    enum action: {
      identity_verification: 0,
      first_crypto_purchase: 1,
      send_to_venmo_user: 2,
      find_wallet_address: 3,
      send_to_external_wallet: 4,
      check_transfer_status: 5
    }

    scope :ordered, -> { order(:action) }

    def steps_ordered
      venmo_guide_steps.order(:sequence)
    end

    def total_steps
      venmo_guide_steps.count
    end

    def progress_for(user)
      venmo_guide_progresses.find_by(user: user)
    end

    def completed_by?(user)
      progress = progress_for(user)
      progress&.completed_at.present?
    end

    def completion_percentage_for(user)
      progress = progress_for(user)
      return 0 unless progress
      progress.completion_percentage
    end
  end
end
