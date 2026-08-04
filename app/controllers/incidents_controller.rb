class IncidentsController < ApplicationController
  def index
    @incidents = Incident.order(created_at: :desc)
  end

  def show
    @incident = Incident.find(params[:id])
  end
end
