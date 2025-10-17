module VenmoCryptoConnector
  class ModulesController < ApplicationController
    before_action :set_module, only: [:show, :complete]

    def show
      unless @module.available_for?(current_user)
        redirect_to dashboard_path, alert: 'This module is not yet available for you.'
        return
      end

      @completion = current_user.module_completions.find_by(education_module: @module)
      @start_time = Time.current
    end

    def complete
      time_spent = params[:time_spent].to_i
      quiz_score = params[:quiz_score]&.to_i

      if @module.completed_by?(current_user)
        redirect_to @module, alert: 'You have already completed this module.'
        return
      end

      @module.complete_for(current_user, time_spent: time_spent, quiz_score: quiz_score)
      
      respond_to do |format|
        format.html { redirect_to dashboard_path, notice: 'Module completed successfully!' }
        format.json { render json: { success: true, xp_earned: 100 } }
      end
    end

    private

    def set_module
      @module = EducationModule.find(params[:id])
    end
  end
end
