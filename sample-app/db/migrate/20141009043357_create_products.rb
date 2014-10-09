class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :seller_id
      t.string :name
      t.integer :cost

      t.timestamps
    end
  end
end
