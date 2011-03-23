class AccessToken < ActiveRecord::Base
  belongs_to :account
  belongs_to :client

  before_validation_on_create :setup
  validates :client, :expires_in, :presence => true
  validates :token, :presence => true, :uniqueness => true

  scope :valid, lambda {
    where('access_tokens.expired_at >= ?', Time.now.utc)
  }

  def expires_in
    (expired_at - Time.now.utc).to_i
  end

  private

  def setup
    self.token = RandomToken.generate
    self.token_type = :bearer
    self.expired_at = 3.hours.from_now
  end
end
