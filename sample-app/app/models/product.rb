class Product < ActiveRecord::Base
  belongs_to :seller
  has_many :orders
  has_many :product_categories
  has_many :categories, through: :product_categories
end
