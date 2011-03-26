class Client < ActiveRecord::Base
  has_many :access_tokens
  has_many :refresh_tokens
  belongs_to :account

  before_validation :setup, :on => :create
  validates :name, :website, :redirect_uri, :account, :presence => true
  validates :identifier, :secret, :presence => true, :uniqueness => true

  private

  def setup
    self.identifier = SecureToken.generate(16)
    self.secret = SecureToken.generate
  end
end
