class AddShipToPeople < ActiveRecord::Migration[5.1]
  def change
    add_reference :people, :ship, foreign_key: true
  end
end
