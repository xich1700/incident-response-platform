# app/services/ai/simulated_client.rb
module Ai
  class SimulatedClient
    class SimulationError < StandardError; end

    def call(model:, system:, user_message:, max_tokens: 1024)
      raise SimulationError, "Simulated AI service outage" if ENV["FORCE_AI_FAILURE"] == "true"

      case system
      when /pattern-matching/i
        simulate_pattern_match(user_message)
      when /root cause/i
        simulate_root_cause(user_message)
      when /investigation steps/i
        simulate_investigation_steps(user_message)
      else
        { note: "no simulation rule matched" }.to_json
      end
    end

    private

    def simulate_pattern_match(_user_message)
      { matched_incident_id: nil, confidence: 0.0, reasoning: "Simulated: treated as new incident" }.to_json
    end

    def simulate_root_cause(user_message)
      error_type = user_message[/error_type:\s*(.+)/, 1] || "UnknownError"
      {
        root_causes: [
          "Simulated cause: unexpected nil value or missing data related to #{error_type}",
          "Simulated cause: recent deploy may have introduced a regression"
        ],
        affected_components: ["Application layer", "Database layer (possible)"]
      }.to_json
    end

    def simulate_investigation_steps(_user_message)
      {
        investigation_steps: [
          "1. Check recent deploy logs for the affected service",
          "2. Reproduce the error in a staging environment",
          "3. Inspect the stack trace for the failing line",
          "4. Check related database records for missing/nil fields"
        ]
      }.to_json
    end
  end
end
