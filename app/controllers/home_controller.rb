# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to conversations_path
    else
      redirect_to new_user_registration_path
    end
  end
end
