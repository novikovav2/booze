class StaticController < ApplicationController
  layout 'statics'

  def index
    if user_signed_in?
      redirect_to events_path
    end
  end

  def welcome

  end
end
