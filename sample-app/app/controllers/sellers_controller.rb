class SellersController < ApplicationController
  before_action :set_seller, only: [:show, :products]

  # GET /sellers
  # GET /sellers.json
  def index
    @sellers = Seller.all
  end

  # GET /sellers/1
  # GET /sellers/1.json
  def show
  end

  # GET /sellers/1/products
  def products
    @products = current_seller.products
  end

  def sold
    @orders = current_seller.products.map do |p|
      p.orders
    end .flatten.sort do |a, b|
      b.created_at <=> a.created_at
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seller
      @seller = Seller.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seller_params
      params.require(:seller).permit(:email, :name)
    end
end
