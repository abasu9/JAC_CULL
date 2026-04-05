import from hr_agent { HRInsightsAgentWalker }

walker ChatEntryWalker {
    has user_input: str = "";

    can chat with Root entry {
        normalized = self.user_input.strip().lower();
        routed_query = self.user_input.strip();

        if normalized.startswith("summarize ") {
            routed_query = self.user_input.strip();
        } elif normalized == "top contributors" {
            routed_query = "show top contributors";
        } elif normalized == "check gaps" {
            routed_query = "check missing employee records";
        } elif normalized == "team summary" {
            routed_query = "prepare a team review summary";
        }

        agent_result = root spawn HRInsightsAgentWalker(query=routed_query);
        response = agent_result.reports[0] if agent_result.reports else {
            "detected_intent": "unknown",
            "actions_used": [],
            "final_result": {}
        };

        report {
            "input": self.user_input,
            "intent": response["detected_intent"],
            "actions_taken": response["actions_used"],
            "result": response["final_result"]
        };
    }
}
