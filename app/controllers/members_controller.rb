class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[add_bot]

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

  private

  def set_event
    @event = Event.find_by_id(params[:id])
  end

  def bot_params
    params.require(:user).permit(:username)
  end
end
