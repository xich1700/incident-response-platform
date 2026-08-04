# Incident Response Platform

An AI-assisted incident response platform for Rails applications. Automatically analyzes high-severity production errors using a multi-agent AI pipeline — detecting incident patterns, identifying root causes, and generating investigation steps for engineers.

Built for the ParisRB.new × AI Tinkerers Paris "Ruby + AI" event.

## Tech Stack

- **Ruby** 3.4.10
- **Rails** 8.1.3
- **PostgreSQL** — primary data store
- **Redis** + **Sidekiq** — background job processing
- **RSpec** — test suite

## Architecture

When a high-severity `ErrorEvent` is created, it triggers an asynchronous multi-agent AI analysis pipeline:

```
ErrorEvent created (high severity)
        │
        ▼
AiIncidentAnalysisJob (Sidekiq, async — never blocks the request)
        │
        ▼
Ai::IncidentAnalysisOrchestrator
   ├─► Agent 1: Ai::PatternMatcherAgent
   │       → matches error against recent incidents, or flags it as new
   ├─► Agent 2: Ai::RootCauseAgent
   │       → root causes + affected components
   └─► Agent 3: Ai::InvestigationStepsAgent
           → concrete next steps, using Agent 2's output as context
        │
        ▼
IncidentAnalysis row saved (status: completed/failed)
```

Each agent has its own narrow system prompt — this mirrors real-world AI-assisted development practices: decomposing a task into smaller, well-scoped agent calls rather than one large prompt, so each step is easier to reason about, test, and debug.

### AI backend

By default, the app uses `Ai::SimulatedClient` — a free, local, rule-based stand-in for an LLM that returns realistic JSON responses in the same shape a real Claude API call would. This keeps the app fully runnable with zero API cost.

Swapping in a real Anthropic API integration is a contained change: implement `Ai::AnthropicClient` (see `app/services/ai/`) and update the `client:` default in each agent — no other code needs to change.

## Data Model

- **Application** — a monitored service (`name`, `environment`, `team_owner`)
- **ErrorEvent** — an incoming production error (`error_type`, `error_message`, `stack_trace`, `severity`)
- **Incident** — a tracked issue (`title`, `status`, `resolved_at`)
- **IncidentNote** — human-written notes on an incident
- **IncidentAnalysis** — AI-generated analysis, kept in its own table, separate from human notes (`root_causes`, `affected_components`, `investigation_steps`, `status`)

## Setup

### Prerequisites

- Ruby 3.4.10
- PostgreSQL and Redis (via Docker is easiest)
- Bundler

### Installation

```bash
bundle install
```

### Start dependencies (Docker)

```bash
docker run -d --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:16
docker run -d --name redis -p 6379:6379 redis:7
```

### Database setup

```bash
bin/rails db:create db:migrate
```

### Run the app

```bash
# Terminal 1 — background job worker
bundle exec sidekiq -q ai_analysis

# Terminal 2 — web server
bin/rails s
```

Visit **http://localhost:3000**.

## Usage

1. Open the dashboard.
2. Click **"Simulate a new error event"**, fill in the form (defaults are pre-filled), and submit.
3. The event is saved immediately — the AI analysis kicks off in the background and does not block the request.
4. On the error event's detail page, refresh after a moment to