module SecureToken
  def self.generate(bytes = 64)
    ActiveSupport::SecureRandom.base64(bytes)
  end
end