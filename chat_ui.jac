import from hr_agent { HRInsightsAgentWalker }

walker ChatUIWalker {
    has query: str = "";

    can run with Root entry {
        normalized = self.query.strip().lower();

        if not self.query.strip() {
            print("===========================");
            print("HR Insights Agent");
            print("===========================");
            print("No query provided.");
            print("Type 'help' to see available commands.");
            report {
                "query": self.query,
                "intent": "empty_query",
                "actions_taken": [],
                "summary": "No query was provided.",
                "key_results": {},
                "errors": ["Empty query"]
            };
            return;
        }

        if normalized == "help" {
            print("===========================");
            print("HR Insights Agent Help");
            print("===========================");
            print("Available commands:");
            print("- summarize <name>");
            print("- explain <name>");
            print("- show <name>");
            print("- top contributors");
            print("- check gaps");
            print("- check missing data");
            print("- team summary");
            print("- backend team summary");
            print("- performance analysis");
            print("- examples");
            print("- exit");
            report {
                "query": self.query,
                "intent": "help",
                "actions_taken": ["help_command"],
                "summary": "Displayed available HR Insights Agent commands.",
                "key_results": {
                    "commands": [
                        "summarize <name>",
                        "explain <name>",
                        "show <name>",
                        "top contributors",
                        "check gaps",
                        "check missing data",
                        "team summary",
                        "backend team summary",
                        "performance analysis",
                        "examples",
                        "exit"
                    ]
                },
                "errors": []
            };
            return;
        }

        if normalized == "examples" {
            print("===========================");
            print("HR Insights Agent Examples");
            print("===========================");
            print("Try queries like:");
            print("- summarize Soureesh Dalal");
            print("- explain Anand Singh");
            print("- show Bhavani Shankar");
            print("- top contributors");
            print("- check missing data");
            print("- team summary");
            print("- backend team summary");
            print("- performance analysis");
            report {
                "query": self.query,
                "intent": "examples",
                "actions_taken": ["examples_command"],
                "summary": "Displayed sample HR Insights Agent queries.",
                "key_results": {
                    "examples": [
                        "summarize Soureesh Dalal",
                        "explain Anand Singh",
                        "show Bhavani Shankar",
                        "top contributors",
                        "check missing data",
                        "team summary",
                        "backend team summary",
                        "performance analysis"
                    ]
                },
                "errors": []
            };
            return;
        }

        if normalized == "exit" {
            print("===========================");
            print("HR Insights Agent");
            print("===========================");
            print("Exit command received. End the current demo session if your environment supports it.");
            report {
                "query": self.query,
                "intent": "exit",
                "actions_taken": ["exit_command"],
                "summary": "Exit command acknowledged.",
                "key_results": {},
                "errors": []
            };
            return;
        }

        agent_result = root spawn HRInsightsAgentWalker(query=self.query);
        response = agent_result.reports[0] if agent_result.reports else {};

        detected_intent = response["intent"] if "intent" in response else "unknown";
        summary = response["summary"] if "summary" in response else "No summary was returned.";
        result_data = response["result"] if "result" in response else {};
        status = response["status"] if "status" in response else "unknown";
        missing_data_flags = response["missing_data_flags"] if "missing_data_flags" in response else [];
        raw_actions = response["actions_taken"] if "actions_taken" in response else [];

        action_names: list[str] = [];
        for action in raw_actions {
            if action and "walker" in action {
                action_names.append(action["walker"]);
            } elif action and "action" in action {
                action_names.append(action["action"]);
            }
        }

        errors: list[str] = [];
        if status == "unknown" {
            errors.append("No workflow status was returned.");
        }
        if result_data and "found" in result_data and not result_data["found"] {
            errors.append(f"Employee not found for query: {self.query}");
        }
        if not result_data and detected_intent not in ["help", "examples", "exit"] {
            errors.append("No data was returned for the query.");
        }

        key_results = result_data;
        if result_data and "structured_summary" in result_data {
            key_results = result_data["structured_summary"];
        }

        print("===========================");
        print("HR Insights Agent Response");
        print("===========================");
        print(f"Query: {self.query}");
        print("");
        print(f"Intent: {detected_intent}");
        print("");
        print("Actions:");
        if action_names {
            for action_name in action_names {
                print(f"- {action_name}");
            }
        } else {
            print("- No actions recorded") ;
        }
        print("");
        print("Summary:");
        print(summary);
        print("");
        print("Key Results:");
        if key_results {
            print(key_results);
        } else {
            print("No structured result data available.");
        }
        print("");
        print("Errors:");
        if errors {
            for err in errors {
                print(f"- {err}");
            }
        } else {
            print("- None");
        }

        report {
            "query": self.query,
            "intent": detected_intent,
            "actions_taken": action_names,
            "summary": summary,
            "key_results": key_results,
            "errors": errors,
            "status": status,
            "missing_data_flags": missing_data_flags
        };
    }
}
