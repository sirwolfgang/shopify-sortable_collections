json.array!(@shops) do |shop|
  json.extract! shop, :id, :token, :uid
  json.url shop_url(shop, format: :json)
end
