# HR Insights Copilot

A hackathon-ready agentic HR insights copilot built with **Jac Builder**, **Jac**, and **Jaseci**.

## Overview
HR Insights Copilot helps HR partners and managers consolidate fragmented employee context into explainable, neutral summaries. It combines APR history, PIP history, compensation context, tenure, and contribution signals into a graph-backed workflow that supports review preparation, documentation quality, and transparency.

## Problem Statement
HR and people managers often need to prepare for review conversations using incomplete or scattered records. Important context may live across APR notes, PIP history, compensation records, tenure data, and contribution signals. This project demonstrates how an agentic Jac system can:
- consolidate these signals,
- detect missing or inconsistent records,
- generate explainable employee summaries,
- surface trends and risk flags,
- support review conversations,
- improve documentation transparency.

## Why This Is Agentic AI
This is more than a static chatbot. The system is agentic because it uses:
- **Intent-based routing** — a query router walker interprets the user request and selects the right workflow.
- **Multi-step reasoning flow** — each workflow decides which fetch and analysis actions to run.
- **Tool/action usage** — helper actions fetch employee profile, APR, PIP, compensation, tenure, and contribution data.
- **Graph-based workflow** — employee context is modeled as connected graph entities in Jac.
- **Explainable outputs** — results include structured context, data gaps, and neutral summaries.

## Jac / Jaseci Architecture
### Graph Entities / Nodes
- `Employee`
- `APRRecord`
- `PIPRecord`
- `CompensationRecord`
- `ContributionRecord`
- `SummaryRecord`
- `DataGapRecord`

### Walkers / Agents
- `QueryRouterWalker` — chat-style entry walker that routes natural language queries.
- `EmployeeSummaryWalker` — consolidates employee context and produces explainable summaries.
- `TopContributorsWalker` — ranks contribution signals and summarizes top contributors.
- `DataGapCheckWalker` — inspects missing or incomplete records.
- `TeamReviewWalker` — prepares team-level review support summaries.
- `RankingPreparationWalker` — creates neutral ranking-prep style context without employment recommendations.

### Tool / Action Layer
- `fetch_employee_profile`
- `fetch_apr_history`
- `fetch_pip_history`
- `fetch_compensation`
- `fetch_tenure`
- `fetch_contributions`
- `detect_data_gaps`
- `prepare_employee_context`
- `summarize_employee_context`
- `summarize_team_context`

## Supported Workflows
### 1. Employee Summary
Examples:
- `Summarize Ava Patel`
- `Explain Maya Singh's performance context`
- `Show Liam Chen's profile`

Behavior:
- fetch employee profile,
- gather APR, PIP, compensation, tenure, and contribution data,
- detect missing fields,
- return structured summary + human-readable explanation.

### 2. Top Contributors
Examples:
- `Show top contributors`
- `Who contributed most recently?`
- `Top 3 employees by contribution`

Behavior:
- inspect contribution records,
- rank by available proxy contribution scores,
- summarize top contributors,
- clearly state this is not a termination or employment decision.

### 3. Data Gap Check
Examples:
- `Which records are incomplete?`
- `Show missing employee data`
- `Check data consistency`

Behavior:
- inspect employees for missing APR, PIP, compensation, tenure, or contribution records,
- create a gap report,
- summarize incompleteness clearly.

### 4. Team Review Summary
Examples:
- `Prepare a Platform team review summary`
- `Show team overview`
- `Give me a review prep summary`

Behavior:
- gather employee contexts for a team,
- summarize patterns, trends, and missing records,
- produce a human-readable team review brief.

### 5. Performance Analysis
Examples:
- `Run employee performance analysis`
- `Analyze employee context`

Behavior:
- orchestrate collection and consolidation of available signals,
- produce explainable outputs,
- avoid high-stakes recommendations.

## Safety and Limitations
### Safety
This system is explicitly designed for:
- employee context summaries,
- data quality flags,
- contribution overviews,
- review support summaries.

This system is **not** designed for:
- firing recommendations,
- retention recommendations,
- termination decisions,
- hiring/firing optimization logic.

### Limitations
- Data is mocked for demo purposes.
- Contribution signals are simplified proxy metrics.
- Outputs support human review and documentation, not automated employment decisions.

## Project Structure
```text
.
├── jac.toml
├── main.jac
├── README.md
├── services/
│   └── hr_service.sv.jac
├── hooks/
│   └── useHRCopilot.cl.jac
├── components/
│   └── hrCopilotApp.cl.jac
└── styles/
    └── global.css
```

## How to Run
```bash
jac install
jac start --dev main.jac
```
Then open the local app in the browser.

## Example Queries
- `Summarize Ava Patel`
- `Show top contributors`
- `Check missing employee records`
- `Prepare a Platform team review summary`
- `Run employee performance analysis`

## Demo Notes
The frontend provides a chat-style interface that sends natural language queries to the backend `chat_query` entrypoint. The backend loads a mock HR graph, routes the query through Jac walkers, executes the relevant tool-style actions, and returns structured, explainable results.
