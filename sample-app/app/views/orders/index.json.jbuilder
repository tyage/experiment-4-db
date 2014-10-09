json.array!(@orders) do |order|
  json.extract! order, :id, :buyer_id, :product_id, :created_at
  json.url order_url(order, format: :json)
end
