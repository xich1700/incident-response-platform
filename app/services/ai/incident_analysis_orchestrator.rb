# app/services/ai/incident_analysis_orchestrator.rb
module Ai
  class IncidentAnalysisOrchestrator
    def initialize(
      pattern_agent: Ai::PatternMatcherAgent.new,
      root_cause_agent: Ai::RootCauseAgent.new,
      steps_agent: Ai::InvestigationStepsAgent.new
    )
      @pattern_agent = pattern_agent
      @root_cause_agent = root_cause_agent
      @steps_agent = steps_agent
    end

    def call(error_event)
      analysis = IncidentAnalysis.create!(error_event: error_event, status: :pending)

      match = @pattern_agent.call(error_event)
      incident = resolve_incident(error_event, match)
      analysis.update!(incident: incident)

      root_cause = @root_cause_agent.call(error_event)
      steps = @steps_agent.call(error_event, root_cause)

      analysis.update!(
        status: :completed,
        root_causes: Array(root_cause[:root_causes]).join("\n"),
        affected_components: Array(root_cause[:affected_components]).join("\n"),
        investigation_steps: Array(steps[:investigation_steps]).join("\n"),
        raw_response: { pattern: match, root_cause: root_cause, steps: steps }
      )
      analysis
    rescue Ai::SimulatedClient::SimulationError => e
      analysis&.update(status: :failed, error_message: e.message)
      raise
    end

    private

    def resolve_incident(error_event, match)
      if match[:matched_incident_id] && match[:confidence].to_f >= 0.7
        Incident.find_by(id: match[:matched_incident_id])
      else
        Incident.create!(
          title: "#{error_event.error_type} in #{error_event.application.name}",
          status: "open",
          error_event: error_event
        )
      end
    end
  end
end
