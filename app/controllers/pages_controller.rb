class PagesController < ApplicationController

  def main
    @user = User.new
    if user_signed_in?
      redirect_to leads_path
    else
      redirect_to new_user_registration_path
    end
  end
end