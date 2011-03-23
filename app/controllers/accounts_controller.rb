class AccountsController < ApplicationController
  before_filter :require_authentication, :only => :update

  def new
    redirect_to dashboard_url if authenticated?
  end

  def update
    current_account.update_attributes(params[:account])
    render :nothing => true
  end
end
