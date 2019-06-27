class EventsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_time_zone, if: :user_signed_in?
    
    def index
      @events = Event.all
      respond_to do |format|
         format.html { render :index }
         format.json { render json: @events, status: 200}
      end
    end   
    
    def show        
      @event = Event.find(params[:id])
      respond_to do |format|
          format.html { render :show }
          format.json { render json: @event, status: 200}
       end
    end                 
  
    def new
      @event = Event.new
    end
  
    def create                         
      @event = @user.events.build(event_params)
  
      if @event.save
        flash[:message] = "YOU HAVE CREATED #{@event.name.upcase}"
        redirect_to event_path(@event)
      else
        render :new
      end
    end
  
    def edit
      # raise params.inspect
      @user = current_user
      @event = Event.find(params[:id])
    end
  
    def update
      @user = current_user
      @event = Event.find(params[:id])
      if @event.update(event_params)
        flash[:message] = "YOU HAVE UPDATED #{@event.name.upcase}"
        respond_to do |format|
          format.html { event_path(@event) }
          format.json { render json: @event, status: 200}
        end
      else
        render :edit
      end
    end
  
    def destroy
      @user = current_user
      @event = Event.find(params[:id])
      @event.destroy
      flash[:message] = "YOU HAVE DELETED #{@event.name.upcase}"
      respond_to do |format|
          format.html { events_path(@user) }
          format.json { render json: {eventId: @event.id}}
      end
    end
   
                                  
  
    private
  
    def event_params
      params.require(:event).permit(:name, :location, :description, :search, :planner_id, :start_date, :end_date)
    end
  
    def set_time_zone
      Time.zone = 'Eastern Time (US & Canada)'
    end
  
    
  end