class Order < ActiveRecord::Base
  has_many :buyer_id
  has_many :product_id
end
