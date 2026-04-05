import from .hr_graph {
    Employee,
    APRRecord,
    PIPRecord,
    CompensationRecord,
    TenureRecord,
    ContributionRecord,
    SummaryRecord,
    DataGapRecord
}

walker EmployeeSummaryWalker {
    has employee_name: str = "";

    can summarize with Root entry {
        target_found = False;

        for emp in [-->][?:Employee] {
            if emp.name.lower() == self.employee_name.strip().lower() {
                target_found = True;
                visit emp;
                return;
            }
        }

        report {
            "employee_name": self.employee_name,
            "found": False,
            "missing_records": ["Employee"],
            "structured_summary": {
                "employee": None,
                "apr_record": None,
                "pip_record": None,
                "compensation_record": None,
                "tenure_record": None,
                "contribution_record": None,
                "missing_records": ["Employee"]
            },
            "summary_text": f"No employee record was found for {self.employee_name}."
        };
    }

    can collect with Employee entry {
        apr_records = [-->][?:APRRecord];
        pip_records = [-->][?:PIPRecord];
        compensation_records = [-->][?:CompensationRecord];
        tenure_records = [-->][?:TenureRecord];
        contribution_records = [-->][?:ContributionRecord];
        summary_records = [-->][?:SummaryRecord];
        gap_records = [-->][?:DataGapRecord];

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
        existing_summary = summary_records[0] if summary_records else None;
        existing_gap = gap_records[0] if gap_records else None;

        if missing_records and not existing_gap {
            here ++> DataGapRecord(missing_fields=missing_records);
        }

        summary_parts = [f"{here.name} is a {here.role} on the {here.team} team."];

        if latest_apr {
            summary_parts.append(f"Latest APR score is {latest_apr.score} for {latest_apr.year}.");
        } else {
            summary_parts.append("APR history is not available.");
        }

        if latest_pip {
            summary_parts.append(f"PIP status is {latest_pip.status} dated {latest_pip.date}.");
        } else {
            summary_parts.append("No PIP record is available in the current graph.");
        }

        if compensation {
            summary_parts.append(f"Compensation band is {compensation.salary_band}.");
        } else {
            summary_parts.append("Compensation data is missing.");
        }

        if tenure {
            summary_parts.append(f"Recorded tenure is {tenure.years} years.");
        } else {
            summary_parts.append("Tenure data is missing.");
        }

        if contribution {
            summary_parts.append(
                f"Contribution signals show {contribution.commits} commits, {contribution.prs} PRs, and {contribution.reviews} reviews."
            );
        } else {
            summary_parts.append("Contribution signals are missing.");
        }

        if missing_records {
            summary_parts.append(f"Missing records detected: {', '.join(missing_records)}.");
        } else {
            summary_parts.append("No missing records were detected across the tracked categories.");
        }

        summary_text = " ".join(summary_parts);

        if not existing_summary {
            here ++> SummaryRecord(text=summary_text);
        }

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
            "missing_records": missing_records,
            "existing_gap_record": existing_gap.missing_fields if existing_gap else None
        };

        report {
            "employee_name": here.name,
            "found": True,
            "missing_records": missing_records,
            "structured_summary": structured_summary,
            "summary_text": summary_text
        };
    }
}
