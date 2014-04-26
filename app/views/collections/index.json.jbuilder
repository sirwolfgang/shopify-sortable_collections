json.array!(@collections) do |collection|
  json.extract! collection, :id, :shopify_id, :shopify_type
  json.url collection_url(collection, format: :json)
end
