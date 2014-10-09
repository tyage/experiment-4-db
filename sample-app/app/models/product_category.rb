class ProductCategory < ActiveRecord::Base
  has_many :products
  has_many :category
end
