class HomeController < ApplicationController
  require 'json'

  def index
  end

  def get_shop_name
    shop_name = params[:shop_name]
    session = ShopifyAPI::Session.new(shop_name<<".myshopify.com")
    scope = ["read_products", "read_orders","read_customers", "write_orders", "write_fulfillments"]
    permission_url = session.create_permission_url(scope, "http://localhost:3000/home/get_token_page")
    redirect_to permission_url
  end

  def get_token_page
    #Already has a permanent access token
    if Store.where(name: params[:shop]).count > 0
      #Getting the exsiting token
      @token = Store.where(name: params[:shop]).first.access_token

    #Instaling app to a new store
    else
      session = ShopifyAPI::Session.new(params[:shop])
      @token = session.request_token(params)

      #Saving the new store
      store = Store.new
      store.name = params[:shop]
      store.access_token = @token
      store.save
    end

    session = ShopifyAPI::Session.new(params[:shop]<<".myshopify.com", @token)
    ShopifyAPI::Base.activate_session(session)
    @products = ShopifyAPI::Product.all
    File.open("public/"<<params[:shop]<<"_products.json","w") do |f|
      json_str = @products.to_json
      j = ActiveSupport::JSON
      f.write JSON.pretty_generate j.decode(json_str)
    end
    @customers = ShopifyAPI::Customer.all
    save_purchases
    webhook
  end

  def webhook
    webhook = ShopifyAPI::Webhook.new
    webhook.topic = "orders\/create"
    webhook.address = "http://requestb.in/1g9ggdy1"
    webhook.format = "json"
    webhook.save
    @webhooks = ShopifyAPI::Webhook.all
  end

  def save_purchases
    Purchase.delete_all
    orders = ShopifyAPI::Order.all
    orders.each do |order|
      order.line_items.each do |line_item|
        purchase = Purchase.new
        purchase.order_id = order.id
        purchase.customer_id = order.customer.id
        purchase.variant_id = line_item.variant_id
        purchase.ordered_at = order.created_at
        purchase.price = line_item.price
        purchase.product_id = line_item.product_id
        purchase.quantity = line_item.quantity
        purchase.save
      end
     end
  end

  def show_purchases
    @purchases = Purchase.all
  end


end
