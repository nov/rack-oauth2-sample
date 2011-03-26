class CreateRefreshTokens < ActiveRecord::Migration
  def self.up
    create_table :refresh_tokens do |t|
      t.belongs_to :account, :client
      t.string :token
      t.datetime :expires_at
      t.timestamps
    end
  end

  def self.down
    drop_table :refresh_tokens
  end
end
