class ClientStatisticsController < ApplicationController
  before_filter :require_oauth_client_token

  def show
    render :json => {
      :access_tokens => {
        :total => current_client.access_tokens.count,
        :valid => current_client.access_tokens.valid.count
      }
    }
  end
end
