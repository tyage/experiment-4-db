require 'test_helper'

class BuyersControllerTest < ActionController::TestCase
  setup do
    @buyer = buyers(:one)
  end

  test "should show buyer" do
    get :show, id: @buyer
    assert_response :success
  end
end
