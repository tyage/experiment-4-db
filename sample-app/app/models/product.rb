class Product < ActiveRecord::Base
  belongs_to :seller
  has_many :orders
  has_many :categories, through: :prodcut_categories
end
