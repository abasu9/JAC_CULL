import from .hr_graph {
    Employee,
    APRRecord,
    PIPRecord,
    CompensationRecord,
    TenureRecord,
    ContributionRecord,
    DataGapRecord
}

walker DataGapCheckWalker {
    can check_gaps with Root entry {
        employees_with_gaps: list[dict] = [];

        for emp in [-->][?:Employee] {
            apr_records = [emp-->][?:APRRecord];
            pip_records = [emp-->][?:PIPRecord];
            compensation_records = [emp-->][?:CompensationRecord];
            tenure_records = [emp-->][?:TenureRecord];
            contribution_records = [emp-->][?:ContributionRecord];

            missing_fields: list[str] = [];

            if not apr_records {
                missing_fields.append("APRRecord");
            }
            if not pip_records {
                missing_fields.append("PIPRecord");
            }
            if not compensation_records {
                missing_fields.append("CompensationRecord");
            }
            if not tenure_records {
                missing_fields.append("TenureRecord");
            }
            if not contribution_records {
                missing_fields.append("ContributionRecord");
            }

            if missing_fields {
                explanation = f"{emp.name} has incomplete HR context because the following records are missing: {', '.join(missing_fields)}.";
                existing_gap_records = [emp-->][?:DataGapRecord];
                gap_record = None;

                if existing_gap_records {
                    gap_record = existing_gap_records[0];
                    gap_record.missing_fields = missing_fields;
                } else {
                    gap_record = (emp ++> DataGapRecord(missing_fields=missing_fields))[0];
                }

                employees_with_gaps.append({
                    "employee_id": emp.id,
                    "employee_name": emp.name,
                    "role": emp.role,
                    "team": emp.team,
                    "missing_fields": missing_fields,
                    "gap_record": {
                        "missing_fields": gap_record.missing_fields
                    },
                    "explanation": explanation
                });
            }
        }

        report {
            "status": "complete",
            "employees_with_missing_data": employees_with_gaps,
            "total_employees_with_gaps": len(employees_with_gaps),
            "missing_data_flags": [
                {
                    "employee_name": item["employee_name"],
                    "missing_fields": item["missing_fields"]
                }
                for item in employees_with_gaps
            ],
            "summary": "Employee data gap check completed. Results highlight incomplete HR records for review support and documentation follow-up."
        };
    }
}
