class Buyer < ActiveRecord::Base
  has_many :orders
end
