class DashboardController < ApplicationController
  def index
    @applications = Application.all
    @recent_error_events = ErrorEvent.order(created_at: :desc).limit(10)
    @recent_incidents = Incident.order(created_at: :desc).limit(10)
  end
end
