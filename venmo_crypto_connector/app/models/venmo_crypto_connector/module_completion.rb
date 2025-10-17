module VenmoCryptoConnector
  class ModuleCompletion < ApplicationRecord
    self.table_name = 'venmo_crypto_connector_module_completions'

    belongs_to :user
    belongs_to :education_module

    validates :user_id, uniqueness: { scope: :education_module_id }
    validates :time_spent_seconds, numericality: { greater_than_or_equal_to: 0 }
    validates :quiz_score, numericality: { in: 0..100 }, allow_nil: true

    scope :completed, -> { where.not(completed_at: nil) }
    scope :recent, -> { order(completed_at: :desc) }

    def completed?
      completed_at.present?
    end

    def time_spent_formatted
      minutes = time_spent_seconds / 60
      seconds = time_spent_seconds % 60
      "#{minutes}m #{seconds}s"
    end

    def performance_rating
      return 'excellent' if quiz_score && quiz_score >= 90
      return 'good' if quiz_score && quiz_score >= 80
      return 'satisfactory' if quiz_score && quiz_score >= 70
      return 'needs_improvement' if quiz_score && quiz_score < 70
      'completed'
    end
  end
end
