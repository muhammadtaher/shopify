class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  require 'json'

  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show_product
    @product = ShopifyAPI::Product.find(params[:product_id])
  end

  def get_customer_variants
    variants = []
    @orders.each do |order|
      order.line_items.each do |item|
        variants << ShopifyAPI::Variant.find(item.variant_id)
      end
    end
    File.open("public/customer_"<<@customer.id.to_s<<"_variants.json","w") do |f|
      json_str = variants.to_json
      j = ActiveSupport::JSON
      f.write JSON.pretty_generate j.decode(json_str)    
    end
  end
  def get_customer_orders
      File.open("public/customer_"<<@customer.id.to_s<<"_orders.json","w") do |f|
      json_str = @orders.to_json
      j = ActiveSupport::JSON
      f.write JSON.pretty_generate j.decode(json_str)    
    end   
  end

  def show_customer_orders
    @customer = ShopifyAPI::Customer.find(params[:customer_id])
    orders = ShopifyAPI::Order.all
    @orders = []
    orders.each do |order|
      if order.customer.id.to_i == @customer.id.to_i
        @orders<< order
      end
    end
    get_customer_variants 
    get_customer_orders 
  end

  def show_variant
    @product = ShopifyAPI::Product.find(params[:product_id])
    variants = @product.variants

    variants.each do |variant|
      if(variant.id == params[:variant_id].to_i)
        @variant = variant
      end
    end

    File.open("public/variant_"<<@product.title<<"_"<<@variant.title.gsub('/','_')<<".json","w") do |f|
      f.write(JSON.pretty_generate(@variant.attributes))
    end

    @product.images.each do |image|
      if image.id == @variant.image_id
        @image = image
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params.require(:store).permit(:access_token, :name)
    end
end
