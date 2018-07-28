class AddSlugToShips < ActiveRecord::Migration[5.2]
  def change
    add_column :ships, :slug, :string
    add_index :ships, :slug, unique: true
  end
end
