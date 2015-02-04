class CreateMemebersParties < ActiveRecord::Migration
  def change
    create_table :members_parties, :id => false do |t|
      t.column :member_id, :integer
      t.column :party_id, :integer
    end
  end
end
