class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.string :address, String, :required => true
      t.string :name, String, :required => true
      t.float :latitude, Float
      t.float :longitude, Float
    end
    add_index :locations, :address
  end

  def down
    drop_table :locations
  end
end
