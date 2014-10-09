class ProductCategory < ActiveRecord::Base
  belongs_to :products
  belongs_to :categories
end
