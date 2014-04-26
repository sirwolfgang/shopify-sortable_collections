module ShopsHelper
  def button_to_create_collection(shopify_id, shopify_type)
    button_to "Make Sortable", { controller: :collections, action: :create, collection: { shopify_id: shopify_id, shopify_type: shopify_type } }, { class: "btn btn-primary" }
  end
end
