# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :redirect_authenticated_user_from_root, if: :devise_controller?
  before_action :set_current_user

  private

  def redirect_authenticated_user_from_root
    return unless user_signed_in? && request.path == '/'

    redirect_to conversations_path
  end

  def set_current_user
    Current.user = current_user
  end
end
