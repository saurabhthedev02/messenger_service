# frozen_string_literal: true

module AuthenticationHelper
  def sign_in(user)
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    follow_redirect!
  end

  def sign_out
    delete destroy_user_session_path
    follow_redirect!
  end
end
