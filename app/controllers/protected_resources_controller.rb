class ProtectedResourcesController < ApplicationController
  before_filter :require_oauth_token

  def index
    render :json => current_account.protected_resources.to_json
  end

  def show
    render :json => current_account.protected_resources.find(params[:id]).to_json
  end

  def create
    resource = current_account.protected_resources.create(:data => params[:data])
    response.location = protected_resource_url(resource)
    render :json => resource.to_json, :status => 201
  end

  def destroy
    current_account.protected_resources.find(params[:id]).destroy
    render :nothing => true, :status => 205
  end
end
