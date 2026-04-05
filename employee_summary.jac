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
        target_name = self.employee_name.strip().lower();

        for emp in [-->][?:Employee] {
            if emp.name.lower() == target_name {
                visit emp;
                return;
            }
        }

        report {
            "employee_name": self.employee_name,
            "found": False,
            "status": "not_found",
            "missing_data_flags": ["Employee"],
            "structured_summary": {
                "employee_overview": None,
                "contribution_context": None,
                "apr_pip_context": None,
                "compensation_context": None,
                "tenure_context": None,
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

        contribution_score = 0;
        if contribution {
            contribution_score = contribution.commits + contribution.prs + contribution.reviews;
        }

        employee_overview = {
            "id": here.id,
            "name": here.name,
            "role": here.role,
            "team": here.team
        };

        contribution_context = {
            "commits": contribution.commits,
            "prs": contribution.prs,
            "reviews": contribution.reviews,
            "score": contribution_score
        } if contribution else None;

        apr_pip_context = {
            "apr": {
                "year": latest_apr.year,
                "score": latest_apr.score
            } if latest_apr else None,
            "pip": {
                "date": latest_pip.date,
                "status": latest_pip.status
            } if latest_pip else None
        };

        compensation_context = {
            "salary_band": compensation.salary_band
        } if compensation else None;

        tenure_context = {
            "years": tenure.years
        } if tenure else None;

        structured_summary = {
            "employee_overview": employee_overview,
            "contribution_context": contribution_context,
            "apr_pip_context": apr_pip_context,
            "compensation_context": compensation_context,
            "tenure_context": tenure_context,
            "missing_records": missing_records
        };

        summary_text = f"{here.name} is a {here.role} on the {here.team} team.";

        if contribution {
            summary_text += f" Contribution context: {contribution.commits} commits, {contribution.prs} PRs, and {contribution.reviews} reviews were recorded, for a combined contribution score of {contribution_score}.";
        } else {
            summary_text += " Contribution context is unavailable because no contribution record was found.";
        }

        if latest_apr and latest_pip {
            summary_text += f" APR/PIP context: the latest APR score is {latest_apr.score} for {latest_apr.year}, and the recorded PIP status is {latest_pip.status} dated {latest_pip.date}.";
        } elif latest_apr {
            summary_text += f" APR/PIP context: the latest APR score is {latest_apr.score} for {latest_apr.year}, and no PIP record is currently available.";
        } elif latest_pip {
            summary_text += f" APR/PIP context: no APR record is currently available, and the recorded PIP status is {latest_pip.status} dated {latest_pip.date}.";
        } else {
            summary_text += " APR/PIP context is limited because no APR or PIP records were found.";
        }

        if compensation {
            summary_text += f" Compensation context shows salary band {compensation.salary_band}.";
        }

        if tenure {
            summary_text += f" Tenure context shows {tenure.years} years with the organization.";
        }

        if missing_records {
            summary_text += f" Missing data note: the following records are not currently available: {", ".join(missing_records)}.";
        } else {
            summary_text += " Missing data note: no record gaps were detected across the tracked HR context fields.";
        }

        summary_text += " This summary is intended to support HR review preparation and documentation quality, and does not make employment decisions.";

        report {
            "employee_name": here.name,
            "found": True,
            "status": "complete" if not missing_records else "partial",
            "missing_data_flags": missing_records,
            "structured_summary": structured_summary,
            "summary_text": summary_text
        };
    }
}
