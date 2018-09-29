class CreateShipComputers < ActiveRecord::Migration[5.2]
  def change
    create_table :ship_computers do |t|
      t.string :reference
      t.references :ship, foreign_key: true
    end
  end
end
