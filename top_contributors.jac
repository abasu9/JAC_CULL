walker TopContributorsWalker {
    can rank with Root entry {
        contributor_rows: list[dict] = [];

        for emp in [-->][?:Employee] {
            contribution_records = [emp-->][?:ContributionRecord];

            if contribution_records {
                contribution = contribution_records[0];
                score = contribution.commits + contribution.prs + contribution.reviews;
                explanation = f"{emp.name} ranks highly because their visible contribution activity includes {contribution.commits} commits, {contribution.prs} PRs, and {contribution.reviews} reviews, producing a strong overall activity score of {score}.";

                contributor_rows.append({
                    "employee_id": emp.id,
                    "employee_name": emp.name,
                    "role": emp.role,
                    "team": emp.team,
                    "contribution_signals": {
                        "commits": contribution.commits,
                        "prs": contribution.prs,
                        "reviews": contribution.reviews
                    },
                    "score": score,
                    "explanation": explanation
                });
            }
        }

        contributor_rows = sorted(contributor_rows, key=lambda item: item["score"], reverse=True);
        top_contributors = contributor_rows[:3];

        report {
            "top_contributors": top_contributors,
            "ranking_basis": "score = commits + prs + reviews",
            "total_ranked_employees": len(contributor_rows),
            "summary": "This ranking is a contribution activity summary based on visible engineering signals. It is intended for review support and transparency, not as an employment recommendation."
        };
    }
}
