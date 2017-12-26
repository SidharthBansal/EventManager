require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:batman)
    @event = events(:party)
    @base_title = "| EventManager"
  end

  test "should get index" do
    get root_path
    assert_response :success
    assert_select "title", "Home #{@base_title}"
  end

  test "should get show" do
    sign_in @user
    get event_path(@event.id)
    assert_response :success
    assert_select "title", "#{@event.title} #{@base_title}"
  end

  test "should get new" do
    sign_in @user
    get new_event_path
    assert_response :success
    assert_select "title", "Create an Event #{@base_title}"
  end

  test "successful create" do
    sign_in @user
    assert_difference "Event.count", 1 do
      post events_path, params: { event: {
        host_id: @user.id,
        title: "New Years Party",
        body: "This is going be the best party ever! Join me on the last day of the year to celebrate
        the arrival of the new year!",
        location: "Fruit Bar",
        date: Time.zone.now } }
    end
    assert_not flash.empty?
    follow_redirect!
    assert_template 'events/show'
  end

  test "should get edit" do
    sign_in @user
    get edit_event_path(@event.id)
    assert_response :success
    assert_select "title", "Update #{@event.title} #{@base_title}"
  end

  test "should update" do
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

  test "should destroy" do
    sign_in @user
    assert_difference "Event.count", -1 do
      delete event_path(@event.id)
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end


end
