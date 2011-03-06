class Account < ActiveRecord::Base
  has_many :access_tokens
  has_many :authorization_codes
  has_many :clients
end
