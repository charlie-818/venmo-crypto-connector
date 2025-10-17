module VenmoCryptoConnector
  class EducationModule < ApplicationRecord
    self.table_name = 'venmo_crypto_connector_education_modules'

    has_many :module_completions, dependent: :destroy
    has_many :users, through: :module_completions

    validates :title, :sequence_number, presence: true
    validates :sequence_number, uniqueness: true
    validates :module_type, inclusion: { in: %w[video interactive quiz reading] }

    scope :ordered, -> { order(:sequence_number) }
    scope :unlocked_for, ->(user) { where('unlock_xp_requirement <= ?', user.experience_points) }

    def available_for?(user)
      user.experience_points >= unlock_xp_requirement &&
      (sequence_number == 1 || previous_module_completed?(user))
    end

    def previous_module_completed?(user)
      return true if sequence_number == 1

      previous_module = EducationModule.find_by(sequence_number: sequence_number - 1)
      return false unless previous_module

      user.module_completions.exists?(education_module: previous_module)
    end

    def completed_by?(user)
      user.module_completions.exists?(education_module: self)
    end

    def complete_for(user, time_spent: 0, quiz_score: nil)
      completion = module_completions.create!(
        user: user,
        time_spent_seconds: time_spent,
        quiz_score: quiz_score,
        completed_at: Time.current
      )

      xp_earned = calculate_xp_reward(quiz_score)
      user.increment!(:experience_points, xp_earned)

      check_unlocks(user)

      completion
    end

    def content_for_display
      case module_type
      when 'video'
        content_data['video_url']
      when 'interactive'
        content_data['interactive_content']
      when 'quiz'
        quiz_questions
      when 'reading'
        content_data['reading_content']
      end
    end

    private

    def calculate_xp_reward(quiz_score)
      base_xp = 100
      return base_xp unless quiz_score

      # Bonus XP for high quiz scores
      bonus_xp = (quiz_score - 70) * 2 if quiz_score >= 70
      base_xp + (bonus_xp || 0)
    end

    def check_unlocks(user)
      case sequence_number
      when 6
        # Unlock external wallet transfer capability
        user.update(can_transfer_external: true) unless user.can_transfer_external?
      when 8
        # Complete onboarding
        user.advance_onboarding_step! if user.onboarding_step == 'external_wallet_connected'
      end
    end
  end
end
