class CreateAuthorizationCodes < ActiveRecord::Migration
  def self.up
    create_table :authorization_codes do |t|
      t.belongs_to :account, :client
      t.string :code
      t.boolean :approved
      t.timestamps
    end
  end

  def self.down
    drop_table :authorization_codes
  end
end
