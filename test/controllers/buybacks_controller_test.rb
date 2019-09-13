require 'test_helper'

class BuybacksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get buybacks_index_url
    assert_response :success
  end

end
