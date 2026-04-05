import from .hr_graph { Employee, ContributionRecord }

walker TopContributorsWalker {
    can rank with Root entry {
        contributor_rows: list[dict] = [];

        for emp in [-->][?:Employee] {
            contribution_records = [emp-->][?:ContributionRecord];

            if contribution_records {
                contribution = contribution_records[0];
                score = contribution.commits + contribution.prs + contribution.reviews;

                contributor_rows.append({
                    "employee_id": emp.id,
                    "employee_name": emp.name,
                    "role": emp.role,
                    "team": emp.team,
                    "commits": contribution.commits,
                    "prs": contribution.prs,
                    "reviews": contribution.reviews,
                    "score": score
                });
            }
        }

        contributor_rows = sorted(contributor_rows, key=lambda item: item["score"], reverse=True);
        top_three = contributor_rows[:3];

        explanation = "Top contributors are ranked using a simple contribution score: commits + PRs + reviews. This is a contribution overview for visibility and review support, not an employment decision.";

        report {
            "top_contributors": top_three,
            "ranking_basis": "score = commits + prs + reviews",
            "total_ranked_employees": len(contributor_rows),
            "explanation": explanation
        };
    }
}
