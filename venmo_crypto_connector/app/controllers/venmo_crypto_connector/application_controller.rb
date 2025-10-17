module VenmoCryptoConnector
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!

    private

    def authenticate_user!
      token = request.headers['Authorization']&.gsub('Bearer ', '') || 
              params[:session_token] ||
              session[:session_token]

      return render_unauthorized unless token

      begin
        payload = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
        user_id = payload[0]['user_id']
        @current_user = User.find(user_id)
        
        unless @current_user.valid_session?
          render_unauthorized
        end
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render_unauthorized
      end
    end

    def current_user
      @current_user
    end

    def render_unauthorized
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
