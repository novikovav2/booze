class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy leave]
  before_action :authenticate_user!

  # GET /events or /events.json
  def index
    @events = []
    @events = (current_user.events.to_a + current_user.member_of.to_a).uniq
  end

  # GET /events/1 or /events/1.json
  def show
    @product = Product.new
    @products = @event.products

    @members = []
    @members << @event.user
    @members = (@members + @event.members.to_a).uniq

    if !@members.include?(current_user)
      redirect_to root_path
    end

  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    # @event = Event.new(event_params)
    @event = current_user.events.new(event_params)
    @event.join_id = (0...8).map { (65 + rand(26)).chr }.join

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
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
        format.html { redirect_to @event, notice: "Event was successfully updated." }
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
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  # GET /join/:id
  def join
    @event = Event.where(join_id: params[:id])[0]
    if @event
      @event.members.push(current_user)
      redirect_to event_path(@event), notice: "Вы стали участником веселья! ;)"
    else
      redirect_to root_path, alert: "Такого мероприятия не найдено ;("
    end
  end

  # GET /leave/:id
  def leave
    @event.members.destroy(current_user)
    redirect_to root_path, notice: 'Вы покинули встречу'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.fetch(:event, {}).permit(:name, :description, :evented_at)
    end
end
