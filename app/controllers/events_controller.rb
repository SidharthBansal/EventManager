class EventsController < ApplicationController

  before_action :logged_in_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :belongs_to_user, only: [:edit, :update]

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    @event_guests = @event.guests
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      flash[:success] = "#{@event.title} created"
      redirect_to @event
    else
      render 'new'
    end

  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:success] = "#{@event.title} updated"
      redirect_to @event
    else
      render 'new'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    flash[:success] = "#{@event.title} was successfully destroyed"
    @event.destroy
    redirect_to root_path
  end

  def add_guest
    @event = Event.find(params[:add][:event_id])
    @guest = User.find(params[:add][:guest_id])
    if !@event.guests.exists?(@guest.id)
      @event.add_guest(@guest)
      flash[:success] = "You joined #{@event.title}"
      redirect_to @event
    else
      flash[:warning] = "You have already joined the event!"
      redirect_to @event
    end
  end

  def remove_guest
    @event = Event.find(params[:add][:event_id])
    @guest = User.find(params[:add][:guest_id])
    if @event.guests.exists?(@guest.id)
      @event.remove_guest(@guest)
      flash[:success] = "You were removed from #{@event.title}"
      redirect_to @event
    else
      flash[:warning] = "Guest wasn't found."
      redirect_to @event
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :body, :location, :date, :guest_id, :picture)
  end

  def logged_in_user
    if !user_signed_in?
      flash[:warning] = "You must be logged in to create an event."
      redirect_to new_user_session_path
    end
  end

  def belongs_to_user
    @event = Event.find(params[:id])
    if current_user.id != @event.host_id
      flash[:warning] = "You can't edit someone else's event!"
      redirect_to @event
    end
  end

end
