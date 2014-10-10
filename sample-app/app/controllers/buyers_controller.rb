class BuyersController < ApplicationController
  before_action :set_buyer, only: [:show]

  # GET /buyers/1
  # GET /buyers/1.json
  def show
  end

  # GET /buyers/orders
  def orders
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_buyer
      @buyer = Buyer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def buyer_params
      params.require(:buyer).permit(:email, :name)
    end
end
