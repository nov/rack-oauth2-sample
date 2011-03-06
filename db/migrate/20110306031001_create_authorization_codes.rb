class CreateAuthorizationCodes < ActiveRecord::Migration
  def self.up
    create_table :authorization_codes do |t|
      t.belongs_to :account, :client
      t.string :code, :redirect_uri
      t.datetime :expired_at
      t.timestamps
    end
  end

  def self.down
    drop_table :authorization_codes
  end
end
