class TelegramController < ApplicationController

  before_action :permit_parameters

  @@bot = TelegramBot.new

  def webhook
    Rails.logger.debug params.inspect
    @@bot.update(params)
    render nothing: true, status: 200
  end

  private

  def permit_parameters
    params.permit!
  end
end
