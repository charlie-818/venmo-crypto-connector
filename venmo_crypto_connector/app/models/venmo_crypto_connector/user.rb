module VenmoCryptoConnector
  class User < ApplicationRecord
    self.table_name = 'venmo_crypto_connector_users'

    # Validations
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :eth_address, uniqueness: true, allow_blank: true
    validates :eth_nonce, presence: true, if: :eth_address?

    # Associations
    has_many :wallet_connections, dependent: :destroy
    has_many :module_completions, dependent: :destroy
    has_many :education_modules, through: :module_completions
    has_many :venmo_guide_progresses, dependent: :destroy
    has_many :simulated_transactions, dependent: :destroy
    has_one :simulated_wallet, dependent: :destroy

    # Enums
    enum onboarding_step: {
      not_started: 0,
      wallet_connected: 1,
      identity_verified: 2,
      first_purchase_completed: 3,
      first_transfer_completed: 4,
      external_wallet_connected: 5,
      onboarding_complete: 6
    }

    # Callbacks
    after_create :create_simulated_wallet
    after_create :generate_eth_nonce

    # Scopes
    scope :onboarded, -> { where.not(onboarded_at: nil) }
    scope :with_wallet, -> { where(wallet_connected: true) }
    scope :verified, -> { where(identity_verified: true) }

    # Instance methods
    def wallet_connected?
      wallet_connections.exists?(verified_at: ..Time.current)
    end

    def identity_verified?
      identity_verified
    end

    def completed_security_tutorial?
      education_modules.exists?(title: 'Security Best Practices')
    end

    def jurisdiction_restricted?
      # This would integrate with a compliance service
      # For now, return false
      false
    end

    def can_transfer_to_external_wallet?
      identity_verified? && 
      wallet_connected? && 
      completed_security_tutorial? &&
      !jurisdiction_restricted?
    end

    def onboarding_progress_percentage
      return 0 if onboarding_step == 'not_started'
      (onboarding_step_before_type_cast.to_f / 6.0 * 100).round
    end

    def next_onboarding_step
      case onboarding_step
      when 'not_started'
        'wallet_connected'
      when 'wallet_connected'
        'identity_verified'
      when 'identity_verified'
        'first_purchase_completed'
      when 'first_purchase_completed'
        'first_transfer_completed'
      when 'first_transfer_completed'
        'external_wallet_connected'
      when 'external_wallet_connected'
        'onboarding_complete'
      else
        'onboarding_complete'
      end
    end

    def advance_onboarding_step!
      next_step = next_onboarding_step
      update!(onboarding_step: next_step)
      
      if next_step == 'onboarding_complete'
        update!(onboarded_at: Time.current)
        increment!(:experience_points, 500) # Bonus XP for completing onboarding
      end
    end

    def generate_new_nonce!
      update!(eth_nonce: SecureRandom.uuid)
    end

    def valid_session?
      session_token.present? && 
      session_expires_at.present? && 
      session_expires_at > Time.current
    end

    def create_session!
      token = JWT.encode(
        { user_id: id, exp: 24.hours.from_now.to_i },
        Rails.application.credentials.secret_key_base
      )
      update!(
        session_token: token,
        session_expires_at: 24.hours.from_now
      )
      token
    end

    def destroy_session!
      update!(session_token: nil, session_expires_at: nil)
    end

    private

    def create_simulated_wallet
      SimulatedWallet.create!(user: self)
    end

    def generate_eth_nonce
      update!(eth_nonce: SecureRandom.uuid) if eth_nonce.blank?
    end
  end
end
