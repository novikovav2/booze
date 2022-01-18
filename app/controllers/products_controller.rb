class ProductsController < ApplicationController

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        @products = Product.all
        format.js
      else
        redirect_to event_path(product_params.event_id)
      end
    end

  end

  private
  def product_params
    params.fetch(:product, {}).permit(:name, :price, :buyer_id, :total, :event_id)
  end
end
