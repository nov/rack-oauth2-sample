class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.belongs_to :account
      t.string :identifier, :secret, :name, :website, :redirect_uri
      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
