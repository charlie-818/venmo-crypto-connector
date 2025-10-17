class HomeController < ApplicationController
  def index
    # Redirect to the crypto onboarding interface
    redirect_to "/crypto"
  end
end
