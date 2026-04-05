# Project: HR Insights Copilot
## Status: DONE
## Plan
1. [x] Review current Jac fullstack setup and syntax docs
2. [x] Replace starter config and entrypoint for HR copilot
3. [x] Add global Tailwind styling
4. [x] Build first renderable UI component and wire it into main
5. [x] Add backend graph schema, mock data, and walkers
6. [x] Connect frontend chat workflow to backend walkers
7. [x] Write README and run validation
## Files
- jac.toml — app config and Vite/Tailwind setup
- main.jac — entry point and backend registration
- styles/global.css — global theme and base styles
- services/hr_service.sv.jac — HR insights backend graph, helpers, and orchestration walkers
- hooks/useHRCopilot.cl.jac — frontend hook for chat workflow
- components/hrCopilotApp.cl.jac — demo UI for query input and results
- README.md — hackathon-quality project documentation
## Issues
- Existing project was a countdown demo and had to be replaced.
- Relative backend import in main.jac caused runtime import error; fixed by using services.hr_service.
- Browser preview appears cached to a different app despite local validation PASS on port 8001.
## Learnings
- Fullstack apps need backend imports in main.jac and sv imports in client hooks.
- CSS should be imported in main.jac with dot-path syntax.
- In .cl.jac, use async can with entry, await def:pub server calls, and named event handlers.
## Last Action
Installed dependencies, started dev server, validated local app response, and completed README + progress tracking.