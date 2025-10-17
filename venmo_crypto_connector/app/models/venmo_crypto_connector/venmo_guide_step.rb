module VenmoCryptoConnector
  class VenmoGuideStep < ApplicationRecord
    self.table_name = 'venmo_crypto_connector_venmo_guide_steps'

    belongs_to :venmo_guide

    validates :title, :step_type, :sequence, presence: true
    validates :sequence, uniqueness: { scope: :venmo_guide_id }

    enum step_type: {
      screenshot: 0,
      video_clip: 1,
      text_instruction: 2,
      checklist: 3,
      warning: 4
    }

    scope :ordered, -> { order(:sequence) }

    def self.for_action(action_name)
      VenmoGuide.find_by(action: action_name)&.venmo_guide_steps&.ordered
    end

    def next_step
      venmo_guide.venmo_guide_steps.find_by(sequence: sequence + 1)
    end

    def previous_step
      venmo_guide.venmo_guide_steps.find_by(sequence: sequence - 1)
    end

    def is_first_step?
      sequence == 1
    end

    def is_last_step?
      sequence == venmo_guide.total_steps
    end

    def step_number
      sequence
    end

    def total_steps
      venmo_guide.total_steps
    end

    def progress_percentage
      (sequence.to_f / total_steps * 100).round
    end
  end
end
