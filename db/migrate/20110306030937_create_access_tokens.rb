class CreateAccessTokens < ActiveRecord::Migration
  def self.up
    create_table :access_tokens do |t|
      t.belongs_to :account, :client
      t.string :token, :token_type
      t.datetime :expired_at
      t.timestamps
    end
  end

  def self.down
    drop_table :access_tokens
  end
end
