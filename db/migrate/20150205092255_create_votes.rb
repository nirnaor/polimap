class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :amount
      t.integer :city_id
      t.integer :party_id

      t.timestamps
    end

  end
end
