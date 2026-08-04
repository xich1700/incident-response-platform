# app/services/ai/root_cause_agent.rb
module Ai
  class RootCauseAgent
    SYSTEM_PROMPT = <<~PROMPT
      You are a senior Rails engineer analyzing a production error (root cause agent).
      Given the error details, list plausible root causes and affected components.
      Respond with ONLY valid JSON:
      {"root_causes": ["...", "..."], "affected_components": ["...", "..."]}
    PROMPT

    def initialize(client: Ai::SimulatedClient.new)
      @client = client
    end

    def call(error_event)
      user_message = <<~MSG
        error_type: #{error_event.error_type}
        error_message: #{error_event.error_message}
        stack_trace: #{error_event.stack_trace}
        application: #{error_event.application.name} (#{error_event.application.environment})
      MSG
      raw = @client.call(model: "sim-root-cause", system: SYSTEM_PROMPT, user_message: user_message, max_tokens: 800)
      JSON.parse(raw, symbolize_names: true)
    end
  end
end
