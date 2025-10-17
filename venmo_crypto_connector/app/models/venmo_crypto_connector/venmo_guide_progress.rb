module VenmoCryptoConnector
  class VenmoGuideProgress < ApplicationRecord
    self.table_name = 'venmo_crypto_connector_venmo_guide_progresses'

    belongs_to :user
    belongs_to :venmo_guide

    validates :user_id, uniqueness: { scope: :venmo_guide_id }
    validates :completed_steps, numericality: { greater_than_or_equal_to: 0 }
    validates :completion_percentage, numericality: { in: 0..100 }

    scope :completed, -> { where.not(completed_at: nil) }
    scope :in_progress, -> { where(completed_at: nil) }

    def current_step
      completed_steps + 1
    end

    def advance_step
      increment!(:completed_steps)
      update_completion_percentage

      if completed_steps >= venmo_guide.total_steps
        complete!
      end
    end

    def complete!
      update!(
        completed_at: Time.current,
        completion_percentage: 100
      )

      # Award XP
      user.increment!(:experience_points, venmo_guide.xp_reward)
    end

    def completed?
      completed_at.present?
    end

    def in_progress?
      !completed? && completed_steps > 0
    end

    def not_started?
      completed_steps == 0 && completed_at.nil?
    end

    def time_spent
      return nil unless completed_at
      (completed_at - created_at).to_i
    end

    def time_spent_formatted
      return 'Not completed' unless time_spent
      
      hours = time_spent / 3600
      minutes = (time_spent % 3600) / 60
      
      if hours > 0
        "#{hours}h #{minutes}m"
      else
        "#{minutes}m"
      end
    end

    private

    def update_completion_percentage
      percentage = (completed_steps.to_f / venmo_guide.total_steps * 100).round
      update!(completion_percentage: percentage)
    end
  end
end
