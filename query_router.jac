walker QueryRouterWalker {
    has query: str = "";

    can route with Root entry {
        normalized = self.query.strip().lower();
        extracted_employee_name = "";
        detected_intent = "employee_summary";
        selected_walker = "EmployeeSummaryWalker";

        if normalized.startswith("summarize ") {
            extracted_employee_name = self.query.strip()[10:].strip();
            detected_intent = "employee_summary";
            selected_walker = "EmployeeSummaryWalker";
        } elif normalized.startswith("explain ") {
            extracted_employee_name = self.query.strip()[8:].strip();
            detected_intent = "employee_summary";
            selected_walker = "EmployeeSummaryWalker";
        } elif normalized.startswith("show ") {
            if "top contributors" in normalized {
                detected_intent = "top_contributors";
                selected_walker = "TopContributorsWalker";
            } else {
                extracted_employee_name = self.query.strip()[5:].strip();
                detected_intent = "employee_summary";
                selected_walker = "EmployeeSummaryWalker";
            }
        } elif "top contributors" in normalized or "top contributor" in normalized or "contributed most" in normalized or "top 3" in normalized {
            detected_intent = "top_contributors";
            selected_walker = "TopContributorsWalker";
        } elif "check gaps" in normalized or "missing data" in normalized or "missing employee records" in normalized or "incomplete" in normalized or "gap" in normalized or "consistency" in normalized {
            detected_intent = "data_gap_check";
            selected_walker = "DataGapCheckWalker";
        } elif "backend team summary" in normalized {
            detected_intent = "team_review_summary";
            selected_walker = "TeamReviewWalker";
        } elif "team summary" in normalized or "team review" in normalized or "team overview" in normalized or "review summary" in normalized or "review prep" in normalized {
            detected_intent = "team_review_summary";
            selected_walker = "TeamReviewWalker";
        } elif "performance analysis" in normalized or "analyze employee" in normalized or "analyze" in normalized or "analysis" in normalized {
            detected_intent = "performance_analysis";
            selected_walker = "EmployeeSummaryWalker";
        }

        report {
            "query": self.query,
            "detected_intent": detected_intent,
            "employee_name": extracted_employee_name,
            "selected_walker": selected_walker
        };
    }
}
