class Order < ActiveRecord::Base
  has_many :buyers
  has_many :products
end
