import from query_router { QueryRouterWalker }
import from employee_summary { EmployeeSummaryWalker }
import from top_contributors { TopContributorsWalker }
import from data_gap_check { DataGapCheckWalker }
import from team_review { TeamReviewWalker }

walker HRInsightsAgentWalker {
    has query: str = "";

    can run with Root entry {
        execution_flow: list[dict] = [];
        actions_taken: list[dict] = [];
        missing_data_flags: list[dict] = [];
        final_result: dict = {};
        status = "completed";
        summary = "HR insights workflow completed with neutral decision-support output.";

        execution_flow.append({
            "step": 1,
            "action": "accept_query",
            "details": {
                "query": self.query,
                "safety_mode": "neutral_decision_support"
            }
        });

        actions_taken.append({
            "type": "routing",
            "walker": "QueryRouterWalker",
            "status": "started"
        });

        router_result = root spawn QueryRouterWalker(query=self.query);
        route_data = router_result.reports[0] if router_result.reports else {
            "query": self.query,
            "detected_intent": "employee_summary",
            "selected_walker": "EmployeeSummaryWalker"
        };

        detected_intent = route_data["detected_intent"];
        selected_walker = route_data["selected_walker"];

        actions_taken[0]["status"] = "completed";
        actions_taken[0]["intent"] = detected_intent;
        actions_taken[0]["selected_walker"] = selected_walker;

        execution_flow.append({
            "step": 2,
            "action": "route_query",
            "walker": "QueryRouterWalker",
            "details": route_data
        });

        if selected_walker == "EmployeeSummaryWalker" {
            employee_name = self.query.strip();
            lowered_query = employee_name.lower();

            if lowered_query.startswith("summarize ") {
                employee_name = employee_name[10:].strip();
            } elif lowered_query.startswith("show ") {
                employee_name = employee_name[5:].strip();
            } elif lowered_query.startswith("explain ") {
                employee_name = employee_name[8:].strip();
            } elif lowered_query.startswith("profile ") {
                employee_name = employee_name[8:].strip();
            } elif lowered_query.startswith("analyze ") {
                employee_name = employee_name[8:].strip();
            }

            actions_taken.append({
                "type": "workflow_execution",
                "walker": "EmployeeSummaryWalker",
                "status": "started",
                "input": {
                    "employee_name": employee_name
                }
            });

            execution_flow.append({
                "step": 3,
                "action": "run_selected_walker",
                "walker": "EmployeeSummaryWalker",
                "details": {
                    "employee_name": employee_name
                }
            });

            summary_result = root spawn EmployeeSummaryWalker(employee_name=employee_name);
            final_result = summary_result.reports[0] if summary_result.reports else {};
            actions_taken[1]["status"] = "completed";
        } elif selected_walker == "TopContributorsWalker" {
            actions_taken.append({
                "type": "workflow_execution",
                "walker": "TopContributorsWalker",
                "status": "started",
                "input": {
                    "query_scope": "all_employees"
                }
            });

            execution_flow.append({
                "step": 3,
                "action": "run_selected_walker",
                "walker": "TopContributorsWalker",
                "details": {
                    "ranking_basis": "commits + prs + reviews"
                }
            });

            top_result = root spawn TopContributorsWalker();
            final_result = top_result.reports[0] if top_result.reports else {};
            actions_taken[1]["status"] = "completed";
        } elif selected_walker == "DataGapCheckWalker" {
            actions_taken.append({
                "type": "workflow_execution",
                "walker": "DataGapCheckWalker",
                "status": "started",
                "input": {
                    "query_scope": "all_employees"
                }
            });

            execution_flow.append({
                "step": 3,
                "action": "run_selected_walker",
                "walker": "DataGapCheckWalker",
                "details": {
                    "scope": "all_employees"
                }
            });

            gap_result = root spawn DataGapCheckWalker();
            final_result = gap_result.reports[0] if gap_result.reports else {};
            actions_taken[1]["status"] = "completed";
        } elif selected_walker == "TeamReviewWalker" {
            actions_taken.append({
                "type": "workflow_execution",
                "walker": "TeamReviewWalker",
                "status": "started",
                "input": {
                    "query_scope": "team_level_summary"
                }
            });

            execution_flow.append({
                "step": 3,
                "action": "run_selected_walker",
                "walker": "TeamReviewWalker",
                "details": {
                    "scope": "team_level_summary"
                }
            });

            team_result = root spawn TeamReviewWalker();
            final_result = team_result.reports[0] if team_result.reports else {};
            actions_taken[1]["status"] = "completed";
        } else {
            actions_taken.append({
                "type": "workflow_execution",
                "walker": "EmployeeSummaryWalker",
                "status": "started",
                "input": {
                    "employee_name": self.query.strip(),
                    "fallback": True
                }
            });

            execution_flow.append({
                "step": 3,
                "action": "run_fallback_walker",
                "walker": "EmployeeSummaryWalker",
                "details": {
                    "employee_name": self.query.strip()
                }
            });

            fallback_result = root spawn EmployeeSummaryWalker(employee_name=self.query.strip());
            final_result = fallback_result.reports[0] if fallback_result.reports else {};
            actions_taken[1]["status"] = "completed";
            selected_walker = "EmployeeSummaryWalker";
        }

        needs_gap_check = False;

        if selected_walker == "EmployeeSummaryWalker" {
            if not final_result {
                needs_gap_check = True;
                missing_data_flags.append({
                    "scope": "workflow",
                    "reason": "empty_result"
                });
            } elif "found" in final_result and not final_result["found"] {
                needs_gap_check = True;
                missing_data_flags.append({
                    "scope": "employee",
                    "reason": "employee_not_found",
                    "employee_name": final_result["employee_name"] if "employee_name" in final_result else self.query
                });
            } elif "missing_records" in final_result and final_result["missing_records"] and len(final_result["missing_records"]) > 0 {
                needs_gap_check = True;
                missing_data_flags.append({
                    "scope": "employee",
                    "reason": "missing_related_records",
                    "employee_name": final_result["employee_name"] if "employee_name" in final_result else self.query,
                    "missing_fields": final_result["missing_records"]
                });
            }
        } elif selected_walker == "TeamReviewWalker" {
            if final_result and "team_summaries" in final_result {
                for team_summary in final_result["team_summaries"] {
                    if team_summary and "missing_data" in team_summary and team_summary["missing_data"] and len(team_summary["missing_data"]) > 0 {
                        needs_gap_check = True;
                        missing_data_flags.append({
                            "scope": "team",
                            "reason": "team_missing_data_detected",
                            "team": team_summary["team"] if "team" in team_summary else "unknown",
                            "missing_data": team_summary["missing_data"]
                        });
                    }
                }
            }
        }

        if needs_gap_check {
            actions_taken.append({
                "type": "follow_up_validation",
                "walker": "DataGapCheckWalker",
                "status": "started",
                "trigger": "incomplete_or_missing_data_detected"
            });

            execution_flow.append({
                "step": 4,
                "action": "run_follow_up_gap_check",
                "walker": "DataGapCheckWalker",
                "details": {
                    "triggered_by": missing_data_flags
                }
            });

            gap_check_result = root spawn DataGapCheckWalker();
            gap_data = gap_check_result.reports[0] if gap_check_result.reports else {};
            actions_taken[len(actions_taken) - 1]["status"] = "completed";

            if final_result {
                final_result["data_gap_check"] = gap_data;
            } else {
                final_result = {
                    "data_gap_check": gap_data
                };
            }

            status = "completed_with_missing_data_flags";
            summary = "Workflow completed with neutral HR insights output and automatic data gap follow-up due to incomplete or missing records.";
        }

        execution_flow.append({
            "step": 5,
            "action": "assemble_response",
            "details": {
                "intent": detected_intent,
                "status": status,
                "missing_data_flag_count": len(missing_data_flags),
                "safety_note": "No firing or retention recommendations are produced."
            }
        });

        report {
            "intent": detected_intent,
            "actions_taken": actions_taken,
            "status": status,
            "result": final_result,
            "summary": summary,
            "missing_data_flags": missing_data_flags
        };
    }
}
