class ApplicationController < ActionController::Base
  before_action do
    :authenticate_user!
    @user ||= current_user
  end
  def index
    if @user
      redirect_to user_lists_path(@user)
    else
      redirect_to new_user_session_path
    end
  end
end
