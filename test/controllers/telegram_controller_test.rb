require 'test_helper'

class TelegramControllerTest < ActionDispatch::IntegrationTest
  test "should get webhook" do
    get telegram_webhook_url
    assert_response :success
  end

end
