import from ..hooks.useRetentionDashboard { useRetentionDashboard }

def:pub RetentionDashboard() -> JsxElement {
    dashboard = useRetentionDashboard();
    employees = dashboard["employees"] if dashboard and "employees" in dashboard and dashboard["employees"] else [];
    result = dashboard["result"] if dashboard and "result" in dashboard and dashboard["result"] else {};
    dimensions = result["normalized_dimensions"] if result and "normalized_dimensions" in result and result["normalized_dimensions"] else [];
    pdf_sections = result["pdf_ready_sections"] if result and "pdf_ready_sections" in result and result["pdf_ready_sections"] else [];
    ppt_sections = result["ppt_ready_sections"] if result and "ppt_ready_sections" in result and result["ppt_ready_sections"] else [];
    guardrails = result["guardrails"] if result and "guardrails" in result and result["guardrails"] else [];
    explanation_chain = result["explanation_chain"] if result and "explanation_chain" in result and result["explanation_chain"] else {};
    employee = result["employee"] if result and "employee" in result and result["employee"] else {};
    orchestrator = result["orchestrator"] if result and "orchestrator" in result and result["orchestrator"] else {};

    def handle_select(e: any) -> None {
        dashboard["setSelectedEmployee"](e.target.value);
    }

    async def handle_run() -> None {
        await dashboard["runEvaluation"]();
    }

    def render_dimension_card(item: any, idx: int) -> JsxElement {
        if not item {
            return <div key={str(idx)} />;
        }
        evidence = item["evidence"] if "evidence" in item and item["evidence"] else [];
        return <div key={str(idx)} className="rounded-3xl border border-border bg-background/40 p-5">
            <div className="flex items-start justify-between gap-4">
                <div>
                    <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">{item["name"] if "name" in item else "dimension"}</div>
                    <div className="mt-2 text-2xl font-bold text-white">{str(item["score"] if "score" in item else "0")}</div>
                </div>
                <div className="rounded-full border border-primary/30 bg-primary/10 px-3 py-2 text-xs font-semibold text-primary">weight {str(item["weight"] if "weight" in item else "0")}</div>
            </div>
            <p className="mt-4 text-sm leading-6 text-muted-foreground">{item["interpretation"] if "interpretation" in item else ""}</p>
            <div className="mt-4 rounded-2xl border border-border bg-card/60 p-4 text-sm text-foreground">{item["conclusion"] if "conclusion" in item else ""}</div>
            <div className="mt-4 flex flex-col gap-2">
                {[<div key={str(ev_idx)} className="rounded-2xl border border-border bg-card-hover/70 px-3 py-2 text-sm text-muted-foreground">{str(ev)}</div> for (ev_idx, ev) in enumerate(evidence) if ev]}
            </div>
        </div>;
    }

    def render_pdf_section(item: any, idx: int) -> JsxElement {
        if not item {
            return <div key={str(idx)} />;
        }
        body = item["body"] if "body" in item and item["body"] else [];
        return <div key={str(idx)} className="rounded-3xl border border-border bg-background/40 p-5">
            <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">{item["section_title"] if "section_title" in item else "section"}</div>
            <div className="mt-4 flex flex-col gap-2">
                {[<div key={str(body_idx)} className="rounded-2xl border border-border bg-card-hover/70 px-3 py-2 text-sm text-muted-foreground">{str(line)}</div> for (body_idx, line) in enumerate(body) if line]}
            </div>
        </div>;
    }

    def render_ppt_section(item: any, idx: int) -> JsxElement {
        if not item {
            return <div key={str(idx)} />;
        }
        bullets = item["bullets"] if "bullets" in item and item["bullets"] else [];
        return <div key={str(idx)} className="rounded-3xl border border-border bg-background/40 p-5">
            <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">{item["slide_title"] if "slide_title" in item else "slide"}</div>
            <div className="mt-4 flex flex-col gap-2">
                {[<div key={str(bullet_idx)} className="rounded-2xl border border-border bg-card-hover/70 px-3 py-2 text-sm text-muted-foreground">{str(line)}</div> for (bullet_idx, line) in enumerate(bullets) if line]}
            </div>
        </div>;
    }

    return <div className="min-h-screen text-foreground">
        <div className="mx-auto flex min-h-screen max-w-7xl flex-col gap-8 px-6 py-8 lg:px-10">
            <section className="grid gap-6 lg:grid-cols-[1.15fr_0.85fr]">
                <div className="rounded-[28px] border border-border bg-card/90 p-8 shadow-[var(--shadow-card)] backdrop-blur">
                    <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-primary/30 bg-primary/10 px-4 py-2 text-sm font-medium text-primary">Employee Retention Decision Support</div>
                    <h1 className="max-w-3xl text-4xl font-extrabold tracking-tight text-white md:text-5xl">Production-oriented retention dashboard with explainable orchestration.</h1>
                    <p className="mt-4 max-w-2xl text-base leading-7 text-muted-foreground md:text-lg">Select a mock employee, route to the correct domain evaluator, normalize dimensions, and review evidence-to-interpretation-to-conclusion outputs with PDF-ready and PPT-ready sections.</p>
                    <div className="mt-8 grid gap-4 rounded-[24px] border border-border bg-background/50 p-5 md:grid-cols-[1fr_auto]">
                        <select value={dashboard["selected_employee_id"] if dashboard and "selected_employee_id" in dashboard else ""} onChange={handle_select} disabled={not (dashboard and "is_logged_in" in dashboard and dashboard["is_logged_in"])} className="min-h-14 rounded-2xl border border-border bg-card px-4 text-base text-foreground outline-none transition focus:border-primary disabled:cursor-not-allowed disabled:opacity-60">
                            {[<option key={employee_item["employee_id"] if employee_item and "employee_id" in employee_item else str(idx)} value={employee_item["employee_id"] if employee_item and "employee_id" in employee_item else ""}>{employee_item["name"] if employee_item and "name" in employee_item else "Employee"}</option> for (idx, employee_item) in enumerate(employees) if employee_item]}
                        </select>
                        <button onClick={handle_run} disabled={not (dashboard and "is_logged_in" in dashboard and dashboard["is_logged_in"])} className="min-h-14 rounded-2xl bg-primary px-6 text-sm font-semibold text-primary-foreground transition hover:opacity-90 focus:outline-none disabled:cursor-not-allowed disabled:opacity-60">{dashboard["running"] and "Running..." or "Run evaluation"}</button>
                    </div>
                    {not (dashboard and "is_logged_in" in dashboard and dashboard["is_logged_in"]) and <div className="mt-4 rounded-2xl border border-warning/40 bg-warning/10 px-4 py-3 text-sm text-warning">Log in first to load retention data.</div>}
                    {dashboard["error"] and <div className="mt-4 rounded-2xl border border-danger/40 bg-danger/10 px-4 py-3 text-sm text-danger">{dashboard["error"]}</div>}
                </div>
                <div className="rounded-[28px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)] backdrop-blur">
                    <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Orchestrator summary</div>
                    <div className="mt-4 grid gap-3">
                        <div className="rounded-2xl border border-border bg-background/50 p-4">
                            <div className="text-sm font-semibold text-success">Role routing</div>
                            <p className="mt-2 text-sm leading-6 text-muted-foreground">{orchestrator and "selected_role_family" in orchestrator and orchestrator["selected_role_family"] or "Awaiting evaluation"}</p>
                        </div>
                        <div className="rounded-2xl border border-border bg-background/50 p-4">
                            <div className="text-sm font-semibold text-warning">Selected evaluator</div>
                            <p className="mt-2 text-sm leading-6 text-muted-foreground">{orchestrator and "selected_evaluator" in orchestrator and orchestrator["selected_evaluator"] or "Awaiting evaluation"}</p>
                        </div>
                        <div className="rounded-2xl border border-border bg-background/50 p-4">
                            <div className="text-sm font-semibold text-accent">Guardrails</div>
                            <p className="mt-2 text-sm leading-6 text-muted-foreground">Decision-support only. Human review remains required.</p>
                        </div>
                    </div>
                </div>
            </section>

            <section className="grid gap-6 lg:grid-cols-[0.9fr_1.1fr]">
                <div className="flex flex-col gap-6">
                    <div className="rounded-[24px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)]">
                        <div className="flex items-center justify-between gap-4">
                            <div>
                                <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Employee snapshot</div>
                                <h2 className="mt-2 text-2xl font-bold text-white">{employee and "name" in employee and employee["name"] or "No employee selected"}</h2>
                            </div>
                            <div className="rounded-full border border-primary/30 bg-primary/10 px-4 py-2 text-xs font-semibold uppercase tracking-[0.2em] text-primary">{result and "risk_band" in result and result["risk_band"] or "pending"} risk</div>
                        </div>
                        <div className="mt-5 grid gap-3 sm:grid-cols-2">
                            <div className="rounded-2xl border border-border bg-background/40 p-4 text-sm text-muted-foreground">Title: {employee and "title" in employee and employee["title"] or ""}</div>
                            <div className="rounded-2xl border border-border bg-background/40 p-4 text-sm text-muted-foreground">Team: {employee and "team" in employee and employee["team"] or ""}</div>
                            <div className="rounded-2xl border border-border bg-background/40 p-4 text-sm text-muted-foreground">Manager: {employee and "manager" in employee and employee["manager"] or ""}</div>
                            <div className="rounded-2xl border border-border bg-background/40 p-4 text-sm text-muted-foreground">Location: {employee and "location" in employee and employee["location"] or ""}</div>
                        </div>
                        <div className="mt-5 rounded-2xl border border-border bg-background/40 p-4">
                            <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Derived retention score</div>
                            <div className="mt-3 text-4xl font-extrabold text-white">{result and "retention_score" in result and str(result["retention_score"]) or "0.0"}</div>
                            <p className="mt-3 text-sm leading-6 text-muted-foreground">{result and "console_report" in result and result["console_report"] or "Run an evaluation to generate the report."}</p>
                        </div>
                    </div>
                    <div className="rounded-[24px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)]">
                        <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Evidence → interpretation → conclusion</div>
                        <div className="mt-4 flex flex-col gap-3">
                            {[<div key={str(idx)} className="rounded-2xl border border-border bg-background/40 px-4 py-3 text-sm text-muted-foreground">{str(item)}</div> for (idx, item) in enumerate(explanation_chain and "evidence" in explanation_chain and explanation_chain["evidence"] or []) if item]}
                            <div className="rounded-2xl border border-border bg-card-hover/70 px-4 py-3 text-sm text-foreground">{explanation_chain and "interpretation" in explanation_chain and explanation_chain["interpretation"] or ""}</div>
                            <div className="rounded-2xl border border-primary/30 bg-primary/10 px-4 py-3 text-sm font-medium text-primary-foreground">{explanation_chain and "conclusion" in explanation_chain and explanation_chain["conclusion"] or ""}</div>
                        </div>
                    </div>
                </div>
                <div className="rounded-[24px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)]">
                    <div className="flex items-center justify-between gap-4">
                        <div>
                            <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Normalized dimensions</div>
                            <h2 className="mt-2 text-2xl font-bold text-white">Auditable scoring inputs</h2>
                        </div>
                        <div className="rounded-full border border-primary/30 bg-primary/10 px-4 py-2 text-xs font-semibold uppercase tracking-[0.2em] text-primary">JSON + report ready</div>
                    </div>
                    <div className="mt-5 grid gap-4">
                        {[render_dimension_card(item, idx) for (idx, item) in enumerate(dimensions) if item]}
                    </div>
                </div>
            </section>

            <section className="grid gap-6 lg:grid-cols-2">
                <div className="rounded-[24px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)]">
                    <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">PDF-ready sections</div>
                    <div className="mt-4 grid gap-4">{[render_pdf_section(item, idx) for (idx, item) in enumerate(pdf_sections) if item]}</div>
                </div>
                <div className="rounded-[24px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)]">
                    <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">PPT-ready sections</div>
                    <div className="mt-4 grid gap-4">{[render_ppt_section(item, idx) for (idx, item) in enumerate(ppt_sections) if item]}</div>
                </div>
            </section>

            <section className="rounded-[24px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)]">
                <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">JSON report and guardrails</div>
                <div className="mt-4 grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
                    <div className="rounded-2xl border border-border bg-background/40 p-4">
                        <pre className="overflow-x-auto whitespace-pre-wrap font-sans text-sm leading-6 text-foreground">{JSON.stringify(result, None, 2)}</pre>
                    </div>
                    <div className="flex flex-col gap-3">
                        {[<div key={str(idx)} className="rounded-2xl border border-border bg-background/40 px-4 py-3 text-sm text-muted-foreground">{str(item)}</div> for (idx, item) in enumerate(guardrails) if item]}
                    </div>
                </div>
            </section>
        </div>
    </div>;
}
