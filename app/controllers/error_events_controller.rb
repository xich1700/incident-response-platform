class ErrorEventsController < ApplicationController
  def index
    @error_events = ErrorEvent.order(created_at: :desc)
  end

  def new
    @error_event = ErrorEvent.new
    @applications = Application.all
  end

  def create
    @error_event = ErrorEvent.new(error_event_params)
    @error_event.occurred_at = Time.current

    if @error_event.save
      redirect_to error_event_path(@error_event), notice: "Error event created. AI analysis is running in the background..."
    else
      @applications = Application.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @error_event = ErrorEvent.find(params[:id])
  end

  private

  def error_event_params
    params.require(:error_event).permit(:application_id, :error_type, :error_message, :stack_trace, :severity)
  end
end
