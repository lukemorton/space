class AddCoordinatesToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :coordinate_x, :int
    add_column :locations, :coordinate_y, :int
    add_column :locations, :coordinate_z, :int
  end
end
