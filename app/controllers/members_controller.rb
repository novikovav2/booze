class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[add_bot leave remove_member]
  before_action :only_members, only: %i[leave]

  # POST /bots/:id
  def add_bot
    bot_email = SecureRandom.hex(20) + '@bot.com'
    bot_password = SecureRandom.base64(12)
    bot = User.new(email: bot_email, password: bot_password, isBot: true)
    bot.skip_confirmation!
    bot.save!

    bot_profile = bot.create_profile
    bot_profile.name = bot_params[:username]
    bot_profile.surname = '(бот)'
    bot_profile.save!

    @event.members.push(bot)
    redirect_to event_path(@event), notice: 'Бот добавлен'
  end

  # GET /join/:id
  def join
    @event = Event.where(join_id: params[:id])[0]
    if @event
      exist_user = @event.members.find_by_id(current_user.id) || @event.user == current_user
      if exist_user
        redirect_to event_path(@event), notice: 'Вы уже являетесь участником веселья! ;)'
      else
        @event.members.push(current_user)
        redirect_to event_path(@event), notice: 'Вы стали участником веселья! ;)'
      end
    else
      redirect_to root_path, alert: 'Такого мероприятия не найдено ;('
    end
  end

  # GET /leave/:id
  def leave
    @event.members.destroy(current_user)
    redirect_to root_path, notice: 'Вы покинули встречу'
  end

  # DELETE /leave/:event_id/:user_id
  def remove_member
    if @event.user == current_user            # Check if current_user is author of event
      user = User.find_by_id(params[:user_id])
      if user                                 # Check if user exist
        is_member = @event.members.include?(user)
        if is_member                          # Check if user is member of event
          # Check if user bought products
          has_products = @event.products.where({ buyer_id: user.id }).length
          if has_products > 0
            redirect_to event_path(@event), alert: 'Участник скидывался на покупки. Его нельзя просто так удалить'
          else
            @event.members.destroy(user)
            if user.isBot
              user.profile.destroy
              user.destroy
            end
            redirect_to event_path(@event), notice: 'Участник удален'
          end
        end
      end
    end
  end

  private

  def set_event
    @event = Event.find_by_id(params[:id])
  end

  def bot_params
    params.require(:user).permit(:username)
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
