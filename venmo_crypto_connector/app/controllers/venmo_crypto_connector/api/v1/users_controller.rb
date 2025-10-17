module VenmoCryptoConnector
  module Api
    module V1
      class UsersController < ApplicationController
        def show
          render json: {
            success: true,
            user: {
              id: current_user.id,
              email: current_user.email,
              username: current_user.username,
              eth_address: current_user.eth_address,
              onboarding_step: current_user.onboarding_step,
              experience_points: current_user.experience_points,
              identity_verified: current_user.identity_verified,
              wallet_connected: current_user.wallet_connected,
              can_transfer_external: current_user.can_transfer_external,
              onboarding_progress: current_user.onboarding_progress_percentage,
              next_onboarding_step: current_user.next_onboarding_step
            }
          }
        end

        def update
          if current_user.update(user_params)
            render json: {
              success: true,
              user: {
                id: current_user.id,
                email: current_user.email,
                username: current_user.username,
                onboarding_step: current_user.onboarding_step,
                experience_points: current_user.experience_points
              }
            }
          else
            render json: {
              success: false,
              errors: current_user.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def stats
          # Get user statistics
          completed_modules = current_user.module_completions.completed.count
          total_xp = current_user.experience_points
          wallet_connections = current_user.wallet_connections.verified.count
          simulated_transactions = current_user.simulated_transactions.confirmed.count

          render json: {
            success: true,
            stats: {
              completed_modules: completed_modules,
              total_xp: total_xp,
              wallet_connections: wallet_connections,
              simulated_transactions: simulated_transactions,
              onboarding_progress: current_user.onboarding_progress_percentage
            }
          }
        end

        private

        def user_params
          params.require(:user).permit(:username, :email, :venmo_username)
        end
      end
    end
  end
end
