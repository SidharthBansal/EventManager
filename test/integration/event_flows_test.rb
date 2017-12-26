require 'test_helper'

class EventFlowsTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:batman)
  end

  test "create an event / not signed in" do
    assert_no_difference "User.count" do
      post events_path params: { event: {
        host_id: @user.id,
        title: "House Warmer Party",
        body: "I just moved in to my new house and we should celebrate!
        Everyone is invited! Come along!!",
        location:"Fruit bar, Spain",
        date:  Time.zone.now } }
    end
    assert_not flash.empty?
    assert_redirected_to new_user_session_path


  end


end
