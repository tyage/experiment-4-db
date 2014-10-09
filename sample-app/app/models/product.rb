class Product < ActiveRecord::Base
  has_many :seller
  has_many :categories, through: :prodcut_categories
end
