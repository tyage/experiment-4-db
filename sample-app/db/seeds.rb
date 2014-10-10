# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = %w(本 食料品 電化製品)
existing_categories = Category.all.pluck(:name)
categories.each do |c|
  unless existing_categories.include?(c)
    Category.create( name: c )
  end
end
