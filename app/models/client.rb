class Client < ActiveRecord::Base
  has_many :access_tokens
  belongs_to :account

  before_validation_on_create :setup
  validates :name, :website, :redirect_uri, :account, :presence => true
  validates :identifier, :secret, :presence => true, :uniqueness => true

  private

  def setup
    self.identifier = RandomToken.generate(32)
    self.secret = RandomToken.generate
  end
end
