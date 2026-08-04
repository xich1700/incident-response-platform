# spec/services/ai/incident_analysis_orchestrator_spec.rb
require "rails_helper"

RSpec.describe Ai::IncidentAnalysisOrchestrator do
  let(:application) { Application.create!(name: "billing-api", environment: "production") }
  let(:error_event) do
    ErrorEvent.create!(application: application, error_type: "NoMethodError",
                       error_message: "undefined method `total' for nil",
                       stack_trace: "app/models/invoice.rb:42", severity: "critical",
                       occurred_at: Time.current)
  end

  it "creates a new incident and stores simulated AI analysis" do
    analysis = described_class.new.call(error_event)

    expect(analysis).to be_completed
    expect(analysis.incident).to be_present
    expect(analysis.root_causes).to be_present
    expect(analysis.investigation_steps).to be_present
  end

  it "marks analysis as failed when the simulated service errors" do
    failing_client = Ai::SimulatedClient.new
    allow(failing_client).to receive(:call).and_raise(Ai::SimulatedClient::SimulationError, "outage")

    # root_cause_agent always calls the client (unlike pattern_agent, which can
    # short-circuit when there are no existing incidents), so inject the failure here.
    root_cause_agent = Ai::RootCauseAgent.new(client: failing_client)
    orchestrator = described_class.new(root_cause_agent: root_cause_agent)

    expect { orchestrator.call(error_event) }.to raise_error(Ai::SimulatedClient::SimulationError)
    expect(IncidentAnalysis.last).to be_failed
  end
end
