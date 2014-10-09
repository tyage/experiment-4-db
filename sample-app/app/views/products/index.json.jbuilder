json.array!(@products) do |product|
  json.extract! product, :id, :seller_id, :name, :cost
  json.url product_url(product, format: :json)
end
