class Account < ActiveRecord::Base
  has_many :protected_resources
  has_many :access_tokens
  has_many :authorization_codes
  has_many :clients
  has_one :facebook, :class_name => 'Auth::Facebook'
end
