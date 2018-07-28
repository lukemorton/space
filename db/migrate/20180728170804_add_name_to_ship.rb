class AddNameToShip < ActiveRecord::Migration[5.2]
  def change
    add_column :ships, :name, :string
  end
end
