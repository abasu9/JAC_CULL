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
            missing_fields: list[str] = [];

            if not [emp-->][?:APRRecord] {
                missing_fields.append("APRRecord");
            }
            if not [emp-->][?:PIPRecord] {
                missing_fields.append("PIPRecord");
            }
            if not [emp-->][?:CompensationRecord] {
                missing_fields.append("CompensationRecord");
            }
            if not [emp-->][?:TenureRecord] {
                missing_fields.append("TenureRecord");
            }
            if not [emp-->][?:ContributionRecord] {
                missing_fields.append("ContributionRecord");
            }

            if missing_fields {
                existing_gap_records = [emp-->][?:DataGapRecord];

                if existing_gap_records {
                    existing_gap_records[0].missing_fields = missing_fields;
                } else {
                    emp ++> DataGapRecord(missing_fields=missing_fields);
                }

                employees_with_gaps.append({
                    "employee_id": emp.id,
                    "employee_name": emp.name,
                    "role": emp.role,
                    "team": emp.team,
                    "missing_fields": missing_fields
                });
            }
        }

        report {
            "employees_with_missing_data": employees_with_gaps,
            "total_employees_with_gaps": len(employees_with_gaps)
        };
    }
}
