# Employee Retention Decision Support

A production-oriented employee retention decision-support system built in Jac with a modular fullstack structure.

## Overview
This project transforms the earlier HR copilot MVP into an auditable retention workflow that:
- accepts an employee id or selected mock employee profile,
- routes the case through an orchestrator,
- determines the employee role family,
- invokes engineering or marketing evaluators,
- normalizes outputs to a shared schema,
- computes a derived retention score,
- explains the result through an evidence → interpretation → conclusion chain,
- produces console/json output plus PDF-ready and PPT-ready report sections.

The system preserves decision-support guardrails: it is designed to support manager and HR review, not to automate employment decisions.

## Architecture

### Backend services
- `services/hr_service.sv.jac` — preserved existing HR copilot service endpoints.
- `services/retention_service.sv.jac` — new retention orchestration service with realistic mock employee data and domain evaluators.

### Frontend
- `hooks/useRetentionDashboard.cl.jac` — data hook that loads mock employees and runs evaluations.
- `components/retentionDashboard.cl.jac` — dashboard UI for selection, execution, explainability, and report rendering.
- `main.jac` — registers backend endpoints and mounts the retention dashboard.
- `styles/global.css` — Tailwind-based styling and theme tokens.

## Retention workflow
1. Select a mock employee.
2. The orchestrator resolves the employee profile and role family.
3. The system invokes:
   - `engineering_evaluator` for engineering employees, or
   - `marketing_evaluator` for marketing employees.
4. Domain outputs are normalized into shared dimensions with:
   - `name`
   - `score`
   - `weight`
   - `weighted_score`
   - `evidence`
   - `interpretation`
   - `conclusion`
5. A derived retention score is computed with explainable adjustments.
6. The final report is returned in:
   - console summary,
   - JSON report,
   - PDF-ready sections,
   - PPT-ready sections.

## Guardrails
- Decision-support only.
- Human review remains required.
- Do not use the score as the sole basis for compensation, promotion, termination, or retention decisions.
- Mock data is realistic but synthetic.

## Project structure
```text
.
├── jac.toml
├── main.jac
├── README.md
├── services/
│   ├── hr_service.sv.jac
│   └── retention_service.sv.jac
├── hooks/
│   ├── useHRCopilot.cl.jac
│   └── useRetentionDashboard.cl.jac
├── components/
│   ├── hrCopilotApp.cl.jac
│   └── retentionDashboard.cl.jac
└── styles/
    └── global.css
```

## Run
```bash
jac install
jac start --dev main.jac
```

## Demo behavior
The dashboard renders a list of mock employees across engineering and marketing. Running an evaluation shows:
- employee snapshot,
- orchestrator routing details,
- normalized dimensions,
- evidence and interpretation chain,
- final retention score and risk band,
- JSON report,
- PDF-ready sections,
- PPT-ready sections.
