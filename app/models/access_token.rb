class AccessToken < ActiveRecord::Base
  include Oauth2Token
  self.default_lifetime = 15.minutes
  belongs_to :refresh_token

  private

  def setup
    super
    if refresh_token
      self.account = refresh_token.account
      self.client = refresh_token.client
      self.expires_at = [self.expires_at, refresh_token.expires_at].min
    end
    self.token_type = :bearer
  end
end
