class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :buyer_id
      t.integer :product_id
      t.datetime :created_at

      t.timestamps
    end
  end
end
