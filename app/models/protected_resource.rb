class ProtectedResource < ActiveRecord::Base
  belongs_to :account
  validate :account, :presence => true

  def as_json(options = {})
    {
      :id => id,
      :data => data
    }
  end
end
