# app/models/incident_analysis.rb
class IncidentAnalysis < ApplicationRecord
  belongs_to :incident, optional: true
  belongs_to :error_event
  enum :status, { pending: "pending", completed: "completed", failed: "failed" }
end


