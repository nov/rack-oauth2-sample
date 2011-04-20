class CreateAccessTokens < ActiveRecord::Migration
  def self.up
    create_table :access_tokens do |t|
      t.belongs_to :account, :client, :refresh_token
      t.string :token
      t.datetime :expires_at
      t.timestamps
    end
  end

  def self.down
    drop_table :access_tokens
  end
end
