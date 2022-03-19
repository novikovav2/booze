class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[destroy add_eater delete_eater]

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        @products = @product.event.products
        format.js { render template: '/products/show_table' }
      else
        redirect_to event_path(product_params.event_id)
      end
    end
  end

  # DELETE /products/:id
  def destroy
    Eater.where({ product_id: @product.id }).destroy_all
    @product.destroy
    @products = @event.products
    respond_to do |format|
      format.json { head :no_content }
      format.js { render template: '/products/show_table' }
    end
  end

  # PUT /products/:id/eaters
  def add_eater
    # @product.eaters.push(current_user)
    Eater.create(product_id: @product.id, user_id: current_user.id)
    @products = @event.products

    respond_to do |format|
      format.js { render template: '/products/show_table' }
    end
  end

  # DELETE /products/:id/eaters
  def delete_eater
    # @product.eaters.delete(current_user)
    Eater.where({ product_id: @product.id, user_id: current_user.id }).destroy_all
    @products = @event.products
    respond_to do |format|
      format.js { render template: '/products/show_table' }
    end
  end

  # POST /products/complete
  # Params: id - event_id
  def addition_complete
    @event = Event.find(params[:id])
    @event.products_complete = !@event.products_complete
    @event.save
    @products = @event.products
    respond_to do |format|
      format.js { render template: '/products/show_table' }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
    @event = @product.event
  end

  def product_params
    params.fetch(:product, {}).permit(:name, :price, :buyer_id, :total, :event_id)
  end
end
