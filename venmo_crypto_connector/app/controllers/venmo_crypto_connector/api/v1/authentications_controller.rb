module VenmoCryptoConnector
  module Api
    module V1
      class AuthenticationsController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :validate_params

        def verify
          result = SiweAuthenticationService.call(
            params[:message],
            params[:signature],
            params[:address]
          )

          if result.success?
            render json: {
              success: true,
              user: {
                id: result.data[:user].id,
                eth_address: result.data[:user].eth_address,
                onboarding_step: result.data[:user].onboarding_step,
                experience_points: result.data[:user].experience_points
              },
              session_token: result.data[:session_token]
            }
          else
            render json: {
              success: false,
              errors: result.errors
            }, status: :unauthorized
          end
        end

        private

        def validate_params
          required_params = [:message, :signature, :address]
          missing_params = required_params.select { |param| params[param].blank? }
          
          if missing_params.any?
            render json: {
              success: false,
              errors: ["Missing required parameters: #{missing_params.join(', ')}"]
            }, status: :bad_request
          end
        end
      end
    end
  end
end
