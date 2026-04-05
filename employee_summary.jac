import from .hr_graph {
    Employee,
    APRRecord,
    PIPRecord,
    CompensationRecord,
    TenureRecord,
    ContributionRecord
}

walker EmployeeSummaryWalker {
    has employee_name: str = "";

    can summarize with Root entry {
        for emp in [-->][?:Employee] {
            if emp.name.lower() == self.employee_name.lower() {
                visit emp;
                return;
            }
        }

        report {
            "employee_name": self.employee_name,
            "found": False,
            "missing_records": ["Employee"],
            "structured_summary": {},
            "summary_text": f"No employee record was found for {self.employee_name}."
        };
    }

    can collect with Employee entry {
        apr_records = [-->][?:APRRecord];
        pip_records = [-->][?:PIPRecord];
        compensation_records = [-->][?:CompensationRecord];
        tenure_records = [-->][?:TenureRecord];
        contribution_records = [-->][?:ContributionRecord];

        missing_records: list[str] = [];
        if not apr_records {
            missing_records.append("APRRecord");
        }
        if not pip_records {
            missing_records.append("PIPRecord");
        }
        if not compensation_records {
            missing_records.append("CompensationRecord");
        }
        if not tenure_records {
            missing_records.append("TenureRecord");
        }
        if not contribution_records {
            missing_records.append("ContributionRecord");
        }

        latest_apr = apr_records[0] if apr_records else None;
        latest_pip = pip_records[0] if pip_records else None;
        compensation = compensation_records[0] if compensation_records else None;
        tenure = tenure_records[0] if tenure_records else None;
        contribution = contribution_records[0] if contribution_records else None;

        structured_summary = {
            "employee": {
                "id": here.id,
                "name": here.name,
                "role": here.role,
                "team": here.team
            },
            "apr_record": {
                "year": latest_apr.year,
                "score": latest_apr.score
            } if latest_apr else None,
            "pip_record": {
                "date": latest_pip.date,
                "status": latest_pip.status
            } if latest_pip else None,
            "compensation_record": {
                "salary_band": compensation.salary_band
            } if compensation else None,
            "tenure_record": {
                "years": tenure.years
            } if tenure else None,
            "contribution_record": {
                "commits": contribution.commits,
                "prs": contribution.prs,
                "reviews": contribution.reviews,
                "score": contribution.commits + contribution.prs + contribution.reviews
            } if contribution else None,
            "missing_records": missing_records
        };

        summary_text = f"{here.name} is a {here.role} on the {here.team} team.";
        if latest_apr {
            summary_text += f" Latest APR score: {latest_apr.score} for {latest_apr.year}.";
        }
        if latest_pip {
            summary_text += f" PIP status: {latest_pip.status} on {latest_pip.date}.";
        }
        if compensation {
            summary_text += f" Salary band: {compensation.salary_band}.";
        }
        if tenure {
            summary_text += f" Tenure: {tenure.years} years.";
        }
        if contribution {
            summary_text += f" Contribution signals include {contribution.commits} commits, {contribution.prs} PRs, and {contribution.reviews} reviews.";
        }
        if missing_records {
            summary_text += f" Missing records detected: {missing_records}.";
        }

        report {
            "employee_name": here.name,
            "found": True,
            "missing_records": missing_records,
            "structured_summary": structured_summary,
            "summary_text": summary_text
        };
    }
}
