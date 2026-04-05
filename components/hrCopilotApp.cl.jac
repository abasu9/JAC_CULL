import from ..hooks.useHRCopilot { useHRCopilot }

def:pub HRCopilotApp() -> JsxElement {
    has selected_query: str = "";
    copilot = useHRCopilot();
    sample_queries = [
        "Summarize Ava Patel",
        "Show top contributors",
        "Check missing employee records",
        "Prepare a Platform team review summary",
        "Run employee performance analysis"
    ];

    result = copilot["result"] if copilot and "result" in copilot and copilot["result"] else {};
    mode = result["mode"] if result and "mode" in result else "overview";
    guardrail = result["guardrail"] if result and "guardrail" in result else "This copilot provides neutral HR decision support only.";
    history = copilot["history"] if copilot and "history" in copilot and copilot["history"] else [];

    def handle_input(e: any) -> None {
        copilot["setQuery"](e.target.value);
    }

    async def handle_submit() -> None {
        await copilot["runQuery"](copilot["query"]);
    }

    async def handle_sample_click() -> None {
        if selected_query {
            await copilot["runQuery"](selected_query);
        }
    }

    def choose_ava() -> None { selected_query = sample_queries[0]; }
    def choose_top() -> None { selected_query = sample_queries[1]; }
    def choose_gap() -> None { selected_query = sample_queries[2]; }
    def choose_team() -> None { selected_query = sample_queries[3]; }
    def choose_analysis() -> None { selected_query = sample_queries[4]; }
    def rerun_first() -> None { if len(history) > 0 and history[0] { selected_query = history[0]["query"] if "query" in history[0] else ""; } }
    def rerun_second() -> None { if len(history) > 1 and history[1] { selected_query = history[1]["query"] if "query" in history[1] else ""; } }
    def rerun_third() -> None { if len(history) > 2 and history[2] { selected_query = history[2]["query"] if "query" in history[2] else ""; } }
    def rerun_fourth() -> None { if len(history) > 3 and history[3] { selected_query = history[3]["query"] if "query" in history[3] else ""; } }
    def rerun_fifth() -> None { if len(history) > 4 and history[4] { selected_query = history[4]["query"] if "query" in history[4] else ""; } }

    def renderList(items: list, empty_text: str) -> JsxElement {
        safe_items = items if items else [];
        return
            <div className="flex flex-col gap-3">
                {len(safe_items) == 0
                and <div className="rounded-2xl border border-dashed border-border bg-background/40 px-4 py-5 text-sm text-muted-foreground">{empty_text}</div>}
                {[
                    <div key={str(idx)} className="rounded-2xl border border-border bg-background/40 p-4 text-sm text-muted-foreground">
                        <pre className="overflow-x-auto whitespace-pre-wrap font-sans leading-6 text-foreground">{JSON.stringify(item, None, 2)}</pre>
                    </div>
                    for (idx, item) in enumerate(safe_items)
                    if item
                ]}
            </div>;
    }

    return
        <div className="min-h-screen text-foreground">
            <div className="mx-auto flex min-h-screen max-w-7xl flex-col gap-8 px-6 py-8 lg:px-10">
                <section className="grid gap-6 lg:grid-cols-[1.15fr_0.85fr]">
                    <div className="rounded-[28px] border border-border bg-card/90 p-8 shadow-[var(--shadow-card)] backdrop-blur">
                        <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-primary/30 bg-primary/10 px-4 py-2 text-sm font-medium text-primary">
                            Agentic HR Insights Copilot
                        </div>
                        <h1 className="max-w-3xl text-4xl font-extrabold tracking-tight text-white md:text-5xl">
                            Explainable HR review support built with Jac, Jac Builder, and Jaseci.
                        </h1>
                        <p className="mt-4 max-w-2xl text-base leading-7 text-muted-foreground md:text-lg">
                            Consolidate APR, PIP, compensation, tenure, and contribution signals into neutral summaries, trend views, and data quality flags without making termination or retention decisions.
                        </p>
                        <div className="mt-8 rounded-[24px] border border-border bg-background/50 p-5">
                            <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Chat-style entry walker</div>
                            <div className="mt-4 flex flex-col gap-3 sm:flex-row">
                                <input
                                    value={copilot["query"] if copilot["query"] else ""}
                                    onChange={handle_input}
                                    placeholder="Ask: Summarize Ava Patel"
                                    className="min-h-14 flex-1 rounded-2xl border border-border bg-card px-4 text-base text-foreground outline-none transition focus:border-primary"
                                />
                                <button
                                    onClick={handle_submit}
                                    className="min-h-14 rounded-2xl bg-primary px-6 text-sm font-semibold text-primary-foreground transition hover:opacity-90 focus:outline-none"
                                >
                                    {copilot["loading"] and "Running..." or "Run workflow"}
                                </button>
                            </div>
                            <div className="mt-4 flex flex-wrap gap-2">
                                <button onClick={choose_ava} className="rounded-full border border-border bg-card-hover px-3 py-2 text-xs font-medium text-muted-foreground transition hover:border-primary/50 hover:text-foreground">{sample_queries[0]}</button>
                                <button onClick={choose_top} className="rounded-full border border-border bg-card-hover px-3 py-2 text-xs font-medium text-muted-foreground transition hover:border-primary/50 hover:text-foreground">{sample_queries[1]}</button>
                                <button onClick={choose_gap} className="rounded-full border border-border bg-card-hover px-3 py-2 text-xs font-medium text-muted-foreground transition hover:border-primary/50 hover:text-foreground">{sample_queries[2]}</button>
                                <button onClick={choose_team} className="rounded-full border border-border bg-card-hover px-3 py-2 text-xs font-medium text-muted-foreground transition hover:border-primary/50 hover:text-foreground">{sample_queries[3]}</button>
                                <button onClick={choose_analysis} className="rounded-full border border-border bg-card-hover px-3 py-2 text-xs font-medium text-muted-foreground transition hover:border-primary/50 hover:text-foreground">{sample_queries[4]}</button>
                                <button onClick={handle_sample_click} className="rounded-full border border-primary/40 bg-primary/10 px-3 py-2 text-xs font-semibold text-primary transition hover:opacity-90">Run selected prompt</button>
                            </div>
                        </div>
                    </div>
                    <div className="rounded-[28px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)] backdrop-blur">
                        <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Why it is agentic</div>
                        <div className="mt-4 grid gap-3">
                            <div className="rounded-2xl border border-border bg-background/50 p-4">
                                <div className="text-sm font-semibold text-success">Intent routing</div>
                                <p className="mt-2 text-sm leading-6 text-muted-foreground">A query router walker decides which workflow to trigger.</p>
                            </div>
                            <div className="rounded-2xl border border-border bg-background/50 p-4">
                                <div className="text-sm font-semibold text-warning">Tool usage</div>
                                <p className="mt-2 text-sm leading-6 text-muted-foreground">Fetch and analysis actions gather APR, PIP, compensation, tenure, and contribution signals.</p>
                            </div>
                            <div className="rounded-2xl border border-border bg-background/50 p-4">
                                <div className="text-sm font-semibold text-accent">Explainability</div>
                                <p className="mt-2 text-sm leading-6 text-muted-foreground">Outputs include structured context, data gaps, and neutral review support notes.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <section className="grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
                    <div className="rounded-[24px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)]">
                        <div className="flex items-center justify-between gap-4">
                            <div>
                                <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Workflow result</div>
                                <h2 className="mt-2 text-2xl font-bold text-white">{mode.replace("_", " ")}</h2>
                            </div>
                            <div className="rounded-full border border-primary/30 bg-primary/10 px-4 py-2 text-xs font-semibold uppercase tracking-[0.2em] text-primary">Decision support only</div>
                        </div>
                        <p className="mt-4 rounded-2xl border border-border bg-background/40 px-4 py-3 text-sm leading-6 text-muted-foreground">{guardrail}</p>
                        <div className="mt-5 rounded-2xl border border-border bg-background/40 p-4">
                            <pre className="overflow-x-auto whitespace-pre-wrap font-sans text-sm leading-6 text-foreground">{JSON.stringify(result, None, 2)}</pre>
                        </div>
                    </div>
                    <div className="flex flex-col gap-6">
                        <div className="rounded-[24px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)]">
                            <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Recent queries</div>
                            <div className="mt-4 flex flex-col gap-3">
                                {len(history) == 0
                                and <div className="rounded-2xl border border-dashed border-border bg-background/40 px-4 py-5 text-sm text-muted-foreground">Run a workflow to populate recent activity.</div>}
                                {len(history) > 0 and history[0] and <button onClick={rerun_first} className="rounded-2xl border border-border bg-background/50 px-4 py-4 text-left transition hover:border-primary/40 hover:bg-card-hover"><div className="text-sm font-semibold text-white">{history[0]["query"] if "query" in history[0] else ""}</div><div className="mt-1 text-xs uppercase tracking-[0.2em] text-muted-foreground">{history[0]["result"]["mode"] if "result" in history[0] and history[0]["result"] and "mode" in history[0]["result"] else "result"}</div></button>}
                                {len(history) > 1 and history[1] and <button onClick={rerun_second} className="rounded-2xl border border-border bg-background/50 px-4 py-4 text-left transition hover:border-primary/40 hover:bg-card-hover"><div className="text-sm font-semibold text-white">{history[1]["query"] if "query" in history[1] else ""}</div><div className="mt-1 text-xs uppercase tracking-[0.2em] text-muted-foreground">{history[1]["result"]["mode"] if "result" in history[1] and history[1]["result"] and "mode" in history[1]["result"] else "result"}</div></button>}
                                {len(history) > 2 and history[2] and <button onClick={rerun_third} className="rounded-2xl border border-border bg-background/50 px-4 py-4 text-left transition hover:border-primary/40 hover:bg-card-hover"><div className="text-sm font-semibold text-white">{history[2]["query"] if "query" in history[2] else ""}</div><div className="mt-1 text-xs uppercase tracking-[0.2em] text-muted-foreground">{history[2]["result"]["mode"] if "result" in history[2] and history[2]["result"] and "mode" in history[2]["result"] else "result"}</div></button>}
                                {len(history) > 3 and history[3] and <button onClick={rerun_fourth} className="rounded-2xl border border-border bg-background/50 px-4 py-4 text-left transition hover:border-primary/40 hover:bg-card-hover"><div className="text-sm font-semibold text-white">{history[3]["query"] if "query" in history[3] else ""}</div><div className="mt-1 text-xs uppercase tracking-[0.2em] text-muted-foreground">{history[3]["result"]["mode"] if "result" in history[3] and history[3]["result"] and "mode" in history[3]["result"] else "result"}</div></button>}
                                {len(history) > 4 and history[4] and <button onClick={rerun_fifth} className="rounded-2xl border border-border bg-background/50 px-4 py-4 text-left transition hover:border-primary/40 hover:bg-card-hover"><div className="text-sm font-semibold text-white">{history[4]["query"] if "query" in history[4] else ""}</div><div className="mt-1 text-xs uppercase tracking-[0.2em] text-muted-foreground">{history[4]["result"]["mode"] if "result" in history[4] and history[4]["result"] and "mode" in history[4]["result"] else "result"}</div></button>}
                            </div>
                        </div>
                        <div className="rounded-[24px] border border-border bg-card/80 p-6 shadow-[var(--shadow-soft)]">
                            <div className="text-sm font-semibold uppercase tracking-[0.2em] text-muted-foreground">Structured highlights</div>
                            <div className="mt-4">
                                {mode == "top_contributors" and renderList(result["results"] if "results" in result else [], "No contribution ranking available.")}
                                {mode == "data_gap_check" and renderList(result["gaps"] if "gaps" in result else [], "No data gaps detected.")}
                                {mode == "team_summary" and renderList(result["members"] if "members" in result else [], "No team members found.")}
                                {mode == "employee_summary" and renderList(result["data_gaps"] if "data_gaps" in result else [], "No data gaps detected for this employee.")}
                                {mode != "top_contributors" and mode != "data_gap_check" and mode != "team_summary" and mode != "employee_summary"
                                and <div className="rounded-2xl border border-dashed border-border bg-background/40 px-4 py-5 text-sm text-muted-foreground">Run a workflow to inspect structured highlights.</div>}
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>;
}
