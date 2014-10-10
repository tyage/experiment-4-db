class OrdersController < ApplicationController
  before_action :authenticate_buyer!, except: [:show]
  before_action :set_order, only: [:show, :destroy]
  before_action :order_buyer, only: [:show, :destroy]

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.buyer = current_buyer

    respond_to do |format|
      if @order.save
        format.html { redirect_to buyer_orders_path, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to buyer_orders_path, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:buyer_id, :product_id, :created_at)
    end

    def order_buyer
      redirect_to root_path unless @order.buyer == current_buyer
    end
end
