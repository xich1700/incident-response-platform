class AiIncidentAnalysisJob
  include Sidekiq::Job
  sidekiq_options queue: :ai_analysis, retry: 3

  sidekiq_retries_exhausted do |job, ex|
    error_event_id = job["args"].first
    IncidentAnalysis.where(error_event_id: error_event_id, status: "pending")
                    .update_all(status: "failed", error_message: "Exhausted retries: #{ex.message}")
  end

  def perform(error_event_id)
    error_event = ErrorEvent.find(error_event_id)
    Ai::IncidentAnalysisOrchestrator.new.call(error_event)
  rescue Ai::SimulatedClient::SimulationError => e
    Rails.logger.error("[AI analysis failed] error_event=#{error_event_id}: #{e.message}")
    raise
  end
end
