require 'test_helper'

class EventFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:batman)
    @other_user = users(:robin)
    @event = events(:party)
  end

  test "create an event / not signed in" do
    assert_no_difference "Event.count" do
      post events_path params: { event: {
        host_id: @user.id,
        title: "House Warmer Party",
        body: "I just moved in to my new house and we should celebrate!
        Everyone is invited! Come along. It's going to be the best party of your life!!",
        location:"Fruit bar, Spain",
        date:  Time.zone.now } }
    end
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test "create an event / signed in" do
    sign_in @user
    assert_difference "Event.count", 1 do
      post events_path params: { event: {
        host_id: @user.id,
        title: "House Warmer Party",
        body: "I just moved in to my new house and we should celebrate!
        Everyone is invited! Come along. It's going to be the best party of your life!!",
        location:"Fruit bar, Spain",
        date:  Time.zone.now } }
    end
    assert_not flash.empty?
    follow_redirect!
    assert_template "events/show"
    assert_select "h1", "House Warmer Party"
  end

  test "update event / not signed in" do
    patch event_path(@event.id), params: { event: {
      title: "Birthday Party",
      body: "This is going be the best party ever! Join me on my birthday to celebrate together
        the day that I was born. Party party party!",
      location: "Fruit Bar",
      date: Time.zone.now } }
      assert_not flash.empty?
      assert_redirected_to new_user_session_path
  end

  test "update event / signed in as wrong user" do
    sign_in @other_user
    patch event_path(@event.id), params: { event: {
      title: "Birthday Party",
      body: "This is going be the best party ever! Join me on my birthday to celebrate together
        the day that I was born. Party party party!",
      location: "Fruit Bar",
      date: Time.zone.now } }
      assert_not flash.empty?
      assert_redirected_to @event
  end

  test "update event / signed in as the right user" do
    sign_in @user
    patch event_path(@event.id), params: { event: {
      title: "Birthday Party",
      body: "This is going be the best party ever! Join me on my birthday to celebrate together
        the day that I was born. Party party party!",
      location: "Fruit Bar",
      date: Time.zone.now } }
      assert_not flash.empty?
      assert_redirected_to @event
      follow_redirect!
      assert_template 'events/show'

  end

end
