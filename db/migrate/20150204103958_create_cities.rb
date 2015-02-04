class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.float :lat, {:precision=>10, :scale=>6}
      t.float :lng, {:precision=>10, :scale=>6}

      t.timestamps
    end
  end
end
