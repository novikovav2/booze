class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[create destroy show eaters update_eaters update]
  before_action :set_product, only: %i[destroy change_eater add_eater delete_eater show update eaters update_eaters]

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        @event = @product.event
        prepare_members
        # Делаем так, что новый продукт ели все участники
        @members.each do |member|
          Eater.create(product_id: @product.id, user_id: member.id)
        end

        @event = @product.event
        prepare_for_form
        @products = @event.products
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
    prepare_members
    respond_to do |format|
      format.html { redirect_to event_path(@event), notice: 'Продукт удален' }
      format.json { head :no_content }
      format.js { render template: '/products/show_table' }
    end
  end

  # POST /products/:id/eater
  def change_eater
    if params[:ate] == "true"
      Eater.create(product_id: @product.id, user_id: current_user.id)
    else
      Eater.where({ product_id: @product.id, user_id: current_user.id }).destroy_all
    end
    @products = @event.products
    @product = Product.new
    prepare_members
    respond_to do |format|
      format.js { render template: '/products/show_table' }
    end
  end

  # PUT /products/:id/eaters
  def add_eater
    # @product.eaters.push(current_user)
    Eater.create(product_id: @product.id, user_id: current_user.id)
    @products = @event.products

    # redirect_to event_path(@event)
    prepare_for_form

    respond_to do |format|
      format.js { render template: '/products/show_table' }
    end
  end

  # DELETE /products/:id/eaters
  def delete_eater
    # @product.eaters.delete(current_user)
    Eater.where({ product_id: @product.id, user_id: current_user.id }).destroy_all
    @products = @event.products

    prepare_for_form
    #redirect_to event_path(@event)

    respond_to do |format|
      format.js { render template: '/products/show_table' }
    end
  end

  # GET /products/:id
  def show; end

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
    # @eaters = User.joins('INNER JOIN eaters ON users.id = eaters.user_id')
    #               .where(eaters: {product_id: @product.id}).to_a.uniq

    @eaters = User.joins('INNER JOIN eaters ON users.id = eaters.user_id')
                   .where(eaters: {product_id: @product.id})
                   .select(:id, 'COUNT(users.id) as count').group(:id)
    @eaters_result = []
    @eaters.each do |eater|
      @eaters_result << {
        id: eater.id,
        count: eater.count,
        username: User.find_by_id(eater.id).username
      }
    end

    prepare_members

    @non_eaters = @members.difference(@eaters)     # Array of event members and not product eaters

    respond_to do |format|
      format.json { render status: :ok}
    end
  end

  # POST /products/:id/eaters
  def update_eaters
    eaters = params[:eaters]
    Eater.where({ product_id: @product.id }).destroy_all
    eaters.each do |eater|
      if eater[:count] && eater[:count] > 0
        (1..eater[:count]).each do |i|
          Eater.create(product_id: @product.id, user_id: eater[:id])
        end
      else
        Eater.create(product_id: @product.id, user_id: eater[:id])
      end
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

  def prepare_for_form
    @product = Product.new
    prepare_members
  end

  def prepare_members
    @members = []
    unless @event.user.isQuest
      @members << @event.user
    end
    @members = (@members + @event.members.to_a).uniq
  end

  def add_eater_private(product, event)
    Eater.create(product_id: product.id, user_id: current_user.id)

    prepare_for_form
  end
end
