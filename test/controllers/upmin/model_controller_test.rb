require 'test_helper'

module Upmin
  class ModelControllerTest < ActionController::TestCase
    test "should get updated_since" do
      get :updated_since
      assert_response :success
    end

  end
end
