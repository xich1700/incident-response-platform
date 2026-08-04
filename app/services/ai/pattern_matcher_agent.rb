# app/services/ai/pattern_matcher_agent.rb
module Ai
  class PatternMatcherAgent
    SYSTEM_PROMPT = <<~PROMPT
      You are a pattern-matching agent for a production incident system.
      You will be given a new error event and a list of recent open/investigating incidents.
      Decide whether the new error is a recurrence of an existing incident.

      Respond with ONLY valid JSON, no markdown, no commentary:
      {"matched_incident_id": <integer or null>, "confidence": <0-1 float>, "reasoning": "<one sentence>"}
    PROMPT

    def initialize(client: Ai::SimulatedClient.new)
      @client = client
    end

    def call(error_event)
      candidates = Incident.where(status: %w[open investigating])
                           .order(created_at: :desc).limit(10)
      return { matched_incident_id: nil, confidence: 0, reasoning: "no candidates" } if candidates.empty?

      user_message = build_prompt(error_event, candidates)
      raw = @client.call(model: "sim-pattern-matcher", system: SYSTEM_PROMPT, user_message: user_message, max_tokens: 300)
      JSON.parse(raw, symbolize_names: true)
    end

    private

    def build_prompt(error_event, candidates)
      <<~MSG
        New error event:
        - type: #{error_event.error_type}
        - message: #{error_event.error_message}
        - stack trace (first 500 chars): #{error_event.stack_trace.to_s.first(500)}

        Recent incidents:
        #{candidates.map { |i| "- id=#{i.id} title=#{i.title} status=#{i.status}" }.join("\n")}
      MSG
    end
  end
end
