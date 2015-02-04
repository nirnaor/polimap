class AddCityIdToMember < ActiveRecord::Migration
  def change
    add_column :members, :city_id, :integer
  end
end
