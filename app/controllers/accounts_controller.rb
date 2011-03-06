class AccountsController < ApplicationController
  def new
    redirect_to dashboard_url if authenticated?
  end
end
