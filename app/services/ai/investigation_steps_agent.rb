# app/services/ai/investigation_steps_agent.rb
module Ai
  class InvestigationStepsAgent
    SYSTEM_PROMPT = <<~PROMPT
      You are an incident response coach (investigation steps agent). Given an error and a
      root-cause analysis, produce a short, ordered, actionable list of investigation steps.
      Respond with ONLY valid JSON:
      {"investigation_steps": ["1. ...", "2. ...", "3. ..."]}
    PROMPT

    def initialize(client: Ai::SimulatedClient.new)
      @client = client
    end

    def call(error_event, root_cause_result)
      user_message = <<~MSG
        error_type: #{error_event.error_type}
        error_message: #{error_event.error_message}
        root_causes: #{root_cause_result[:root_causes]&.join("; ")}
        affected_components: #{root_cause_result[:affected_components]&.join("; ")}
      MSG
      raw = @client.call(model: "sim-investigation-steps", system: SYSTEM_PROMPT, user_message: user_message, max_tokens: 500)
      JSON.parse(raw, symbolize_names: true)
    end
  end
end
