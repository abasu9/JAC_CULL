walker QueryRouterWalker {
    has query: str = "";

    can route with Root entry {
        normalized = self.query.strip().lower();
        detected_intent = "employee_summary";
        selected_walker = "EmployeeSummaryWalker";

        if "top contributor" in normalized or "top contributors" in normalized or "contributed most" in normalized or "top 3" in normalized {
            detected_intent = "top_contributors";
            selected_walker = "TopContributorsWalker";
        } elif "missing" in normalized or "incomplete" in normalized or "gap" in normalized or "consistency" in normalized {
            detected_intent = "data_gap_check";
            selected_walker = "DataGapCheckWalker";
        } elif "team review" in normalized or "team overview" in normalized or "review summary" in normalized or "review prep" in normalized or "team summary" in normalized {
            detected_intent = "team_review_summary";
            selected_walker = "TeamReviewWalker";
        } elif "performance analysis" in normalized or "analyze employee" in normalized or "analyze" in normalized or "analysis" in normalized {
            detected_intent = "performance_analysis";
            selected_walker = "EmployeeSummaryWalker";
        } elif "summarize" in normalized or "profile" in normalized or "performance context" in normalized or "employee" in normalized {
            detected_intent = "employee_summary";
            selected_walker = "EmployeeSummaryWalker";
        }

        report {
            "query": self.query,
            "detected_intent": detected_intent,
            "selected_walker": selected_walker
        };
    }
}
