class CreateProtectedResources < ActiveRecord::Migration
  def self.up
    create_table :protected_resources do |t|
      t.belongs_to :account
      t.text :data
      t.timestamps
    end
  end

  def self.down
    drop_table :protected_resources
  end
end
