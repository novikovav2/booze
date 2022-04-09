class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[destroy add_eater delete_eater show update eaters update_eaters]

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to event_path(@product.event.id), notice: 'Продукт добавлен'
    else
      redirect_to event_path(@product.event.id), alert: 'Упппс, не получилось'
    end

    # respond_to do |format|
    #   if @product.save
    #     @products = @product.event.products
    #     format.js { render template: '/products/show_table' }
    #   else
    #     redirect_to event_path(product_params.event_id)
    #   end
    # end
  end

  # DELETE /products/:id
  def destroy
    Eater.where({ product_id: @product.id }).destroy_all
    @product.destroy
    @products = @event.products
    respond_to do |format|
      format.html { redirect_to event_path(@event), notice: 'Продукт удален' }
      format.json { head :no_content }
      format.js { render template: '/products/show_table' }
    end
  end

  # PUT /products/:id/eaters
  def add_eater
    # @product.eaters.push(current_user)
    Eater.create(product_id: @product.id, user_id: current_user.id)
    @products = @event.products

    redirect_to event_path(@event)

    # respond_to do |format|
    #   format.js { render template: '/products/show_table' }
    # end
  end

  # DELETE /products/:id/eaters
  def delete_eater
    # @product.eaters.delete(current_user)
    Eater.where({ product_id: @product.id, user_id: current_user.id }).destroy_all
    @products = @event.products

    redirect_to event_path(@event)

    # respond_to do |format|
    #   format.js { render template: '/products/show_table' }
    # end
  end

  # POST /products/complete
  # Params: id - event_id
  # def addition_complete
  #   @event = Event.find(params[:id])
  #   @event.products_complete = !@event.products_complete
  #   @event.save
  #   @products = @event.products
  #   respond_to do |format|
  #     format.js { render template: '/products/show_table' }
  #   end
  # end

  # GET /products/:id
  def show

  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.json { render json: @product, status: :ok }
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /products/:id/eaters
  def eaters
    @eaters = User.joins('INNER JOIN eaters ON users.id = eaters.user_id')
                  .where(eaters: {product_id: @product.id}).to_a.uniq

    members = []
    members << @event.user
    members = (members + @event.members.to_a).uniq

    @non_eaters = members.difference(@eaters)     # Array of event members and not product eaters

    respond_to do |format|
      format.json { render status: :ok}
    end
  end

  # POST /products/:id/eaters
  def update_eaters
    eaters = params[:eaters]
    Eater.where({ product_id: @product.id }).destroy_all
    eaters.each do |eater|
      Eater.create(product_id: @product.id, user_id: eater[:id])
    end
    respond_to do |format|
      format.json { render json: { success: true }, status: :ok }
    end
  end

  private

  def set_product
    @product = Product.find_by_id(params[:id])
    @event = @product.event
  end

  def product_params
    params.fetch(:product, {}).permit(:name, :price, :buyer_id, :total, :event_id)
  end
end
