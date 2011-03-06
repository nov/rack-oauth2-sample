class CreateAuthFacebooks < ActiveRecord::Migration
  def self.up
    create_table :auth_facebooks do |t|
      t.belongs_to :account
      t.string :identifier, :unsigned => true, :limit => 20
      t.string :access_token
      t.timestamps
    end
  end

  def self.down
    drop_table :auth_facebooks
  end
end
