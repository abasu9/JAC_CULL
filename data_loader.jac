import from .hr_graph {
    Employee,
    APRRecord,
    PIPRecord,
    CompensationRecord,
    TenureRecord,
    ContributionRecord
}

walker DataLoaderWalker {
    can load with Root entry {
        # High contributor with complete records.
        ava = (root() ++> Employee(
            id="EMP-1001",
            name="Ava Patel",
            role="Senior Backend Engineer",
            team="Platform"
        ))[0];
        ava ++> APRRecord(year=2024, score=4.8);
        ava ++> PIPRecord(date="2023-11-15", status="completed");
        ava ++> CompensationRecord(salary_band="L5");
        ava ++> TenureRecord(years=5.2);
        ava ++> ContributionRecord(commits=420, prs=96, reviews=181);

        # Medium contributor with complete records.
        ryan = (root() ++> Employee(
            id="EMP-1002",
            name="Ryan Chen",
            role="Software Engineer",
            team="Applications"
        ))[0];
        ryan ++> APRRecord(year=2024, score=3.9);
        ryan ++> PIPRecord(date="2022-06-20", status="not_applicable");
        ryan ++> CompensationRecord(salary_band="L4");
        ryan ++> TenureRecord(years=2.8);
        ryan ++> ContributionRecord(commits=168, prs=41, reviews=63);

        # Low contributor with a recent active support plan.
        maya = (root() ++> Employee(
            id="EMP-1003",
            name="Maya Singh",
            role="QA Engineer",
            team="Platform"
        ))[0];
        maya ++> APRRecord(year=2024, score=2.8);
        maya ++> PIPRecord(date="2024-08-01", status="active");
        maya ++> CompensationRecord(salary_band="L3");
        maya ++> TenureRecord(years=1.4);
        maya ++> ContributionRecord(commits=29, prs=8, reviews=12);

        # Employee with intentionally missing records for data-gap testing.
        leo = (root() ++> Employee(
            id="EMP-1004",
            name="Leo Martinez",
            role="Data Analyst",
            team="Operations"
        ))[0];
        leo ++> APRRecord(year=2024, score=3.2);
        leo ++> TenureRecord(years=0.9);
        # Intentionally missing PIPRecord, CompensationRecord, and ContributionRecord.

        report {
            "status": "loaded",
            "employees_created": 4,
            "profiles": [
                {"name": "Ava Patel", "category": "high_contributor"},
                {"name": "Ryan Chen", "category": "medium_contributor"},
                {"name": "Maya Singh", "category": "low_contributor"},
                {"name": "Leo Martinez", "category": "missing_records"}
            ]
        };
    }
}
