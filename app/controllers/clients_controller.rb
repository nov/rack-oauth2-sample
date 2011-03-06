class ClientsController < ApplicationController
  before_filter :require_authentication

  def show
    @client = Client.find params[:id]
  end

  def new
    @client = current_account.clients.new params[:client]
  end

  def create
    new
    if @client.save
      redirect_to client_url(@client)
    else
      p @client.errors.full_messages
      render :new
    end
  end
end
