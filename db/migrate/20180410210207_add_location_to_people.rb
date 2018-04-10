class AddLocationToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :location, :string
  end
end
