import from query_router { QueryRouterWalker }
import from employee_summary { EmployeeSummaryWalker }
import from top_contributors { TopContributorsWalker }
import from data_gap_check { DataGapCheckWalker }
import from team_review { TeamReviewWalker }

walker HRInsightsAgentWalker {
    has query: str = "";

    can run with Root entry {
        execution_flow: list[dict] = [];
        walkers_used: list[str] = [];
        actions_used: list[str] = [];

        execution_flow.append({
            "step": 1,
            "action": "accept_query",
            "details": {
                "query": self.query
            }
        });

        router_result = root spawn QueryRouterWalker(query=self.query);
        walkers_used.append("QueryRouterWalker");
        actions_used.append("intent_detection");

        route_data = router_result.reports[0] if router_result.reports else {
            "query": self.query,
            "detected_intent": "employee_summary",
            "selected_walker": "EmployeeSummaryWalker"
        };

        detected_intent = route_data["detected_intent"];
        selected_walker = route_data["selected_walker"];

        execution_flow.append({
            "step": 2,
            "action": "route_query",
            "walker": "QueryRouterWalker",
            "details": route_data
        });

        final_result: dict = {};

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
            }

            walkers_used.append("EmployeeSummaryWalker");
            actions_used.append("fetch_employee_context");
            actions_used.append("detect_missing_records");
            actions_used.append("generate_employee_summary");

            execution_flow.append({
                "step": 3,
                "action": "invoke_walker",
                "walker": "EmployeeSummaryWalker",
                "details": {
                    "employee_name": employee_name
                }
            });

            summary_result = root spawn EmployeeSummaryWalker(employee_name=employee_name);
            final_result = summary_result.reports[0] if summary_result.reports else {};
        } elif selected_walker == "TopContributorsWalker" {
            walkers_used.append("TopContributorsWalker");
            actions_used.append("fetch_contribution_records");
            actions_used.append("rank_contributors");
            actions_used.append("generate_contribution_explanation");

            execution_flow.append({
                "step": 3,
                "action": "invoke_walker",
                "walker": "TopContributorsWalker",
                "details": {
                    "ranking_basis": "commits + prs + reviews"
                }
            });

            top_result = root spawn TopContributorsWalker();
            final_result = top_result.reports[0] if top_result.reports else {};
        } elif selected_walker == "DataGapCheckWalker" {
            walkers_used.append("DataGapCheckWalker");
            actions_used.append("inspect_employee_records");
            actions_used.append("detect_data_gaps");
            actions_used.append("update_gap_records");

            execution_flow.append({
                "step": 3,
                "action": "invoke_walker",
                "walker": "DataGapCheckWalker",
                "details": {
                    "scope": "all_employees"
                }
            });

            gap_result = root spawn DataGapCheckWalker();
            final_result = gap_result.reports[0] if gap_result.reports else {};
        } elif selected_walker == "TeamReviewWalker" {
            walkers_used.append("TeamReviewWalker");
            actions_used.append("aggregate_team_context");
            actions_used.append("analyze_team_trends");
            actions_used.append("summarize_team_review_context");

            execution_flow.append({
                "step": 3,
                "action": "invoke_walker",
                "walker": "TeamReviewWalker",
                "details": {
                    "scope": "team_level_summary"
                }
            });

            team_result = root spawn TeamReviewWalker();
            final_result = team_result.reports[0] if team_result.reports else {};
        } else {
            walkers_used.append("EmployeeSummaryWalker");
            actions_used.append("fallback_employee_summary");

            execution_flow.append({
                "step": 3,
                "action": "invoke_fallback_walker",
                "walker": "EmployeeSummaryWalker",
                "details": {
                    "employee_name": self.query.strip()
                }
            });

            fallback_result = root spawn EmployeeSummaryWalker(employee_name=self.query.strip());
            final_result = fallback_result.reports[0] if fallback_result.reports else {};
        }

        execution_flow.append({
            "step": 4,
            "action": "collect_final_result",
            "details": {
                "detected_intent": detected_intent,
                "walkers_used": walkers_used,
                "actions_used": actions_used
            }
        });

        report {
            "query": self.query,
            "detected_intent": detected_intent,
            "walkers_used": walkers_used,
            "actions_used": actions_used,
            "execution_flow": execution_flow,
            "final_result": final_result
        };
    }
}
