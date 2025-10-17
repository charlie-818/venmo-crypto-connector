module VenmoCryptoConnector
  class DashboardController < ApplicationController
    def index
      @user = current_user
      @available_modules = EducationModule.unlocked_for(@user).ordered
      @completed_modules = @user.education_modules.ordered
      @recent_transactions = @user.simulated_transactions.recent.limit(5)
      @simulated_wallet = @user.simulated_wallet
      @onboarding_progress = @user.onboarding_progress_percentage
      @next_step = @user.next_onboarding_step
    end
  end
end
