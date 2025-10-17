module VenmoCryptoConnector
  class VenmoGuidesController < ApplicationController
    before_action :set_guide, only: [:show, :complete]
    before_action :set_current_step, only: [:show]

    def show
      @steps = @guide.steps_ordered
      @progress = @guide.progress_for(current_user)
      @current_step_index = @current_step ? @current_step.sequence - 1 : 0
      @current_step = @steps[@current_step_index] if @current_step_index < @steps.length
    end

    def complete
      progress = @guide.progress_for(current_user) || 
                 @guide.venmo_guide_progresses.create!(user: current_user)
      
      progress.complete!

      respond_to do |format|
        format.html { redirect_to dashboard_path, notice: 'Guide completed successfully!' }
        format.json { render json: { success: true, xp_earned: @guide.xp_reward } }
      end
    end

    private

    def set_guide
      @guide = VenmoGuide.find(params[:id])
    end

    def set_current_step
      step_number = params[:step]&.to_i
      if step_number && step_number > 0
        @current_step = @guide.venmo_guide_steps.find_by(sequence: step_number)
      end
    end
  end
end
