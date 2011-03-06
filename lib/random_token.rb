module RandomToken
  def self.generate(length = 64)
    Base64.encode64(OpenSSL::Random.random_bytes(length)).gsub(/\n/, '')
  end
end