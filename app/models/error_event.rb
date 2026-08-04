# app/models/error_event.rb
class ErrorEvent < ApplicationRecord
  belongs_to :application
  has_one :incident_analysis
  validates :error_type, :error_message, :severity, presence: true

  after_create_commit :trigger_ai_analysis, if: :high_severity?

  def high_severity?
    severity.in?(%w[critical high])
  end

  private

  def trigger_ai_analysis
    AiIncidentAnalysisJob.perform_async(id)
  end
end

