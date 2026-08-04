# spec/jobs/ai_incident_analysis_job_spec.rb
require "rails_helper"

RSpec.describe AiIncidentAnalysisJob do
  let(:application) { Application.create!(name: "app", environment: "production") }
  let(:error_event) { ErrorEvent.create!(application: application, error_type: "Timeout", error_message: "x", severity: "high", occurred_at: Time.current) }

  it "invokes the orchestrator" do
    expect_any_instance_of(Ai::IncidentAnalysisOrchestrator).to receive(:call).with(error_event)
    described_class.new.perform(error_event.id)
  end
end
