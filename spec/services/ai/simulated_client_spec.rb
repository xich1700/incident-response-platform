# spec/services/ai/simulated_client_spec.rb
require "rails_helper"

RSpec.describe Ai::SimulatedClient do
  it "returns pattern-matching JSON for pattern system prompt" do
    result = subject.call(model: "x", system: "pattern-matching agent", user_message: "hi")
    parsed = JSON.parse(result, symbolize_names: true)
    expect(parsed).to have_key(:matched_incident_id)
  end

  it "raises SimulationError when forced" do
    ENV["FORCE_AI_FAILURE"] = "true"
    expect { subject.call(model: "x", system: "root cause", user_message: "hi") }
      .to raise_error(Ai::SimulatedClient::SimulationError)
    ENV["FORCE_AI_FAILURE"] = nil
  end
end
