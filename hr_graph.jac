# Agentic HR insights graph schema.
# Employee nodes connect to record nodes that capture explainable HR context.

node Employee {
    has id: str = "EMP-1001";
    has name: str = "Ava Patel";
    has role: str = "Senior Backend Engineer";
    has team: str = "Platform";
}

node APRRecord {
    has year: int = 2024;
    has score: float = 4.2;
}

node PIPRecord {
    has date: str = "2024-09-15";
    has status: str = "completed";
}

node CompensationRecord {
    has salary_band: str = "L4";
}

node TenureRecord {
    has years: float = 3.5;
}

node ContributionRecord {
    has commits: int = 128;
    has prs: int = 34;
    has reviews: int = 57;
}

node SummaryRecord {
    has text: str = "Consistent contributor with stable performance context and clear documentation signals.";
}

node DataGapRecord {
    has missing_fields: list[str] = ["pip_history", "salary_band_source"];
}

walker InitHRGraph {
    can seed with Root entry {
        emp = (root() ++> Employee(
            id="EMP-1001",
            name="Ava Patel",
            role="Senior Backend Engineer",
            team="Platform"
        ))[0];

        emp ++> APRRecord(year=2024, score=4.2);
        emp ++> PIPRecord(date="2024-09-15", status="completed");
        emp ++> CompensationRecord(salary_band="L4");
        emp ++> TenureRecord(years=3.5);
        emp ++> ContributionRecord(commits=128, prs=34, reviews=57);
        emp ++> SummaryRecord(text="Consistent contributor with stable performance context and clear documentation signals.");
        emp ++> DataGapRecord(missing_fields=["pip_history", "salary_band_source"]);
    }
}
