class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy results change_status]
  before_action :authenticate_user!
  before_action :only_members, only: %i[show edit update destroy results]

  # GET /events or /events.json
  def index
    @events = []
    @events = (current_user.events.to_a + current_user.member_of.to_a).uniq

    @active_events = (current_user.events.active.to_a + current_user.member_of.active.to_a).uniq
    @archived_events = (current_user.events.archived.to_a + current_user.member_of.archived.to_a).uniq

  end

  # GET /events/1 or /events/1.json
  def show
    @bot = User.new
    @product = Product.new
    @products = @event.products

    @members = []
    @members << @event.user
    @members = (@members + @event.members.to_a).uniq

    @owner = @event.user == current_user
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    # @event = Event.new(event_params)
    @event = current_user.events.new(event_params)
    @event.join_id = (0...8).map { rand(65..90).chr }.join

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Событие было успешно обновлено' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Событие было успешно удалено' }
      format.json { head :no_content }
    end
  end

  # GET /events/:id/results
  def results
    @members = []
    @members << @event.user
    @members += @event.members

    @results = []
    @members.each do |member|
      # Это объект с полями:
      # user - объект User
      # spent - сколько потратил покупая продукты
      # debt - сколько остался должен после того, как съел продукты
      result = {}
      result['user'] = member
      result['spent'] = @event.products.where({ buyer_id: member.id }).sum(:price)

      debt = 0
      @event.products.each do |product|
        count = 0
        if Eater.where({ product_id: product.id, user_id: member.id }).length > 0
          # Убеждаемся, что пользователь вообще ел данный продукт

          if product.total
            # Если продукт исчисляемый
            count = Eater.where({ product_id: product.id }).length
            part_user = Eater.where({ product_id: product.id, user_id: member.id }).length
            debt += (product.price * part_user) / count
          else
            # Если продукт неисчисляемый

            # считаем сколько всего человек ело данный продукт
            count = Eater.where({ product_id: product.id }).select(:user_id).distinct.length
            debt += product.price / count
          end
        end
      end
      result['debt'] = debt

      @results << result
    end
  end

  # POST /events/:id/change_status
  def change_status
    if @event.user == current_user
      @event.active? ? @event.archived! : @event.active!
      redirect_to events_path, notice: 'Статус мероприятия изменен'
    else
      redirect_to event_path(@event), alert: 'Вы не организатор этого мероприятия'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find_by_id(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.fetch(:event, {}).permit(:name, :description, :evented_at)
  end

  def only_members
    members = []
    members << @event.user
    members += @event.members
    # Если пользователь не участник встречи - перенаправляем на главную,
    # чтобы не видел результаты
    redirect_to root_path unless members.include?(current_user)
  end
end
