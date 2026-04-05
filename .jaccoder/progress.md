## Status: DONE
## Plan
1. [x] Review current Jac fullstack setup and syntax docs
2. [x] Inspect existing HR copilot source and preserve minimal fullstack structure
3. [x] Add modular retention orchestration service with role-specific evaluators
4. [x] Add dashboard hook and component for employee selection and explainable results
5. [x] Register endpoints in main.jac and keep Tailwind styling active
6. [x] Update README and validate app startup path
## Files
- jac.toml — existing app config with Vite/Tailwind plugin preserved
- main.jac — registers retention endpoints and mounts retention dashboard
- services/hr_service.sv.jac — preserved legacy HR copilot service
- services/retention_service.sv.jac — new orchestrator, mock data, evaluators, normalization, scoring, and report builders
- hooks/useRetentionDashboard.cl.jac — frontend hook for loading employees and running evaluations
- components/retentionDashboard.cl.jac — dashboard UI for explainable retention decision support
- styles/global.css — preserved Tailwind theme and global styling
- README.md — updated architecture and usage documentation
## Issues
- Existing project centered on chat-style HR copilot flows, so the simplest low-disruption path was to preserve the old service and mount a new retention dashboard.
- Retention workflow was implemented with realistic mock data to avoid invasive graph refactors while keeping backend changes modular and auditable.
## Learnings
- Jac fullstack apps require backend endpoint imports in main.jac and sv imports in client hooks.
- Tailwind remains active through jac.toml Vite plugin config and CSS import in main.jac.
- Shared normalized schemas and explicit evidence chains make retention scoring auditable without removing guardrails.
## Last Action
Implemented the retention service, wired the dashboard frontend, updated docs, and marked the project complete.
