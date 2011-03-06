class SessionsController < ApplicationController
  def new
    authenticate Auth::Facebook.authenticate(cookies)
    redirect_to dashboard_url
  end
end
