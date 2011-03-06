class AuthorizationCode < ActiveRecord::Base
  belongs_to :account
  belongs_to :client

  before_validation_on_create :setup
  validates :account, :client, :redirect_uri, :expired_at, :presence => true
  validates :code, :presence => true, :uniqueness => true

  scope :valid, lambda {
    where('authorization_codes.expired_at >= ?', Time.now.utc)
  }

  def access_token
    @access_token ||= expired! && account.access_tokens.create(:client => client)
  end

  private

  def expired!
    self.expired_at = Time.now.utc
    self.save!
  end

  def setup
    self.code = RandomToken.generate
    self.expired_at = 3.minutes.from_now
  end
end
