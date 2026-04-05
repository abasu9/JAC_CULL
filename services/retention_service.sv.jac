node EmployeeProfile {
    has employee_id: str = "";
    has name: str = "";
    has role_family: str = "";
    has title: str = "";
    has team: str = "";
    has manager: str = "";
    has location: str = "";
    has tenure_years: float = 0.0;
    has level: str = "";
    has engagement_signal: float = 0.0;
    has mobility_interest: str = "";
    has flight_risk_note: str = "";
}

def mock_employees() -> list {
    return [
        {
            "employee_id": "E-1001",
            "name": "Ava Patel",
            "role_family": "engineering",
            "title": "Senior Software Engineer",
            "team": "Platform",
            "manager": "Nina Brooks",
            "location": "Austin, TX",
            "tenure_years": 3.8,
            "level": "L4",
            "engagement_signal": 0.62,
            "mobility_interest": "high",
            "flight_risk_note": "Asked about internal mobility and market compensation in the last quarter.",
            "performance_rating": "Exceeds",
            "delivery_predictability": 0.81,
            "code_review_load": 0.77,
            "incident_load": 0.72,
            "manager_support": 0.58,
            "compa_ratio": 0.91,
            "market_pressure": 0.74,
            "recognition_signal": 0.55,
            "campaign_ownership": 0.0,
            "pipeline_coverage": 0.0,
            "brand_visibility": 0.0,
            "cross_functional_load": 0.63,
            "recent_evidence": [
                "Led the service reliability migration with two weekend incidents in the same month.",
                "APR notes cite strong execution but limited growth path clarity.",
                "Compa ratio is below peer midpoint for the level."
            ]
        },
        {
            "employee_id": "E-1002",
            "name": "Liam Chen",
            "role_family": "engineering",
            "title": "Staff Data Engineer",
            "team": "Data Platform",
            "manager": "Priya Raman",
            "location": "Seattle, WA",
            "tenure_years": 5.4,
            "level": "L5",
            "engagement_signal": 0.79,
            "mobility_interest": "medium",
            "flight_risk_note": "Stable performer with selective interest in architecture leadership.",
            "performance_rating": "Strong",
            "delivery_predictability": 0.88,
            "code_review_load": 0.69,
            "incident_load": 0.41,
            "manager_support": 0.74,
            "compa_ratio": 1.02,
            "market_pressure": 0.52,
            "recognition_signal": 0.71,
            "campaign_ownership": 0.0,
            "pipeline_coverage": 0.0,
            "brand_visibility": 0.0,
            "cross_functional_load": 0.57,
            "recent_evidence": [
                "Mentors two engineers and owns quarterly data quality reviews.",
                "Compensation is near market midpoint.",
                "Recent pulse survey comments mention healthy manager support."
            ]
        },
        {
            "employee_id": "M-2001",
            "name": "Maya Singh",
            "role_family": "marketing",
            "title": "Senior Growth Marketing Manager",
            "team": "Demand Generation",
            "manager": "Elena Torres",
            "location": "New York, NY",
            "tenure_years": 2.6,
            "level": "M4",
            "engagement_signal": 0.57,
            "mobility_interest": "medium",
            "flight_risk_note": "High external recruiter activity and concern about campaign resourcing.",
            "performance_rating": "Strong",
            "delivery_predictability": 0.0,
            "code_review_load": 0.0,
            "incident_load": 0.0,
            "manager_support": 0.61,
            "compa_ratio": 0.94,
            "market_pressure": 0.78,
            "recognition_signal": 0.59,
            "campaign_ownership": 0.86,
            "pipeline_coverage": 0.73,
            "brand_visibility": 0.67,
            "cross_functional_load": 0.82,
            "recent_evidence": [
                "Owns two major launch campaigns with stretched agency support.",
                "Pipeline contribution is strong but recognition in QBR was limited.",
                "Asked about promotion timing and role scope in skip-level meeting."
            ]
        },
        {
            "employee_id": "M-2002",
            "name": "Jordan Alvarez",
            "role_family": "marketing",
            "title": "Product Marketing Lead",
            "team": "Product Marketing",
            "manager": "Elena Torres",
            "location": "Chicago, IL",
            "tenure_years": 4.1,
            "level": "M5",
            "engagement_signal": 0.83,
            "mobility_interest": "low",
            "flight_risk_note": "Low immediate risk; values strategic influence and team stability.",
            "performance_rating": "Exceeds",
            "delivery_predictability": 0.0,
            "code_review_load": 0.0,
            "incident_load": 0.0,
            "manager_support": 0.8,
            "compa_ratio": 1.01,
            "market_pressure": 0.46,
            "recognition_signal": 0.84,
            "campaign_ownership": 0.79,
            "pipeline_coverage": 0.69,
            "brand_visibility": 0.81,
            "cross_functional_load": 0.64,
            "recent_evidence": [
                "Led successful enterprise launch messaging with strong sales adoption.",
                "Receives visible executive recognition.",
                "No recent signals of external search behavior."
            ]
        }
    ];
}

def find_mock_employee(employee_id: str) -> dict {
    lowered = employee_id.lower();
    for employee in mock_employees() {
        if employee["employee_id"].lower() == lowered or employee["name"].lower() == lowered {
            return employee;
        }
    }
    return {};
}

def normalize_dimension(name: str, score: float, weight: float, evidence: list, interpretation: str, conclusion: str) -> dict {
    weighted_score = score * weight;
    return {
        "name": name,
        "score": round(score, 3),
        "weight": round(weight, 3),
        "weighted_score": round(weighted_score, 3),
        "evidence": evidence,
        "interpretation": interpretation,
        "conclusion": conclusion
    };
}

def build_chain(evidence: list, interpretation: str, conclusion: str) -> dict {
    return {
        "evidence": evidence,
        "interpretation": interpretation,
        "conclusion": conclusion
    };
}

def engineering_evaluator(profile: dict) -> dict {
    workload_pressure = (profile["incident_load"] + profile["code_review_load"] + profile["cross_functional_load"]) / 3.0;
    growth_support = (profile["manager_support"] + profile["recognition_signal"]) / 2.0;
    reward_alignment = 1.0 - abs(1.0 - profile["compa_ratio"]);
    dimensions = [
        normalize_dimension(
            "workload_sustainability",
            1.0 - workload_pressure,
            0.34,
            [
                "Incident load: " + str(profile["incident_load"]),
                "Code review load: " + str(profile["code_review_load"]),
                "Cross-functional load: " + str(profile["cross_functional_load"])
            ] + profile["recent_evidence"],
            "Engineering retention is sensitive to sustained operational load and review burden.",
            "Current workload sustainability is " + ("fragile" if workload_pressure > 0.68 else "manageable") + "."
        ),
        normalize_dimension(
            "growth_and_support",
            growth_support,
            0.33,
            [
                "Manager support: " + str(profile["manager_support"]),
                "Recognition signal: " + str(profile["recognition_signal"]),
                "Mobility interest: " + profile["mobility_interest"]
            ],
            "Employees with visible support and growth clarity are more likely to stay.",
            "Growth support is " + ("below target" if growth_support < 0.62 else "supportive") + "."
        ),
        normalize_dimension(
            "reward_competitiveness",
            (reward_alignment + (1.0 - profile["market_pressure"])) / 2.0,
            0.33,
            [
                "Compa ratio: " + str(profile["compa_ratio"]),
                "Market pressure: " + str(profile["market_pressure"]),
                profile["flight_risk_note"]
            ],
            "Compensation and external demand shape retention pressure for engineering talent.",
            "Reward competitiveness is " + ("at risk" if profile["compa_ratio"] < 0.95 else "acceptable") + "."
        )
    ];
    return {
        "role_family": "engineering",
        "dimensions": dimensions,
        "domain_summary": "Engineering evaluator emphasizes workload sustainability, growth support, and reward competitiveness."
    };
}

def marketing_evaluator(profile: dict) -> dict {
    campaign_strain = (profile["campaign_ownership"] + profile["cross_functional_load"] + profile["market_pressure"]) / 3.0;
    visibility = (profile["brand_visibility"] + profile["recognition_signal"]) / 2.0;
    reward_alignment = 1.0 - abs(1.0 - profile["compa_ratio"]);
    dimensions = [
        normalize_dimension(
            "campaign_capacity",
            1.0 - campaign_strain,
            0.34,
            [
                "Campaign ownership: " + str(profile["campaign_ownership"]),
                "Cross-functional load: " + str(profile["cross_functional_load"]),
                "Market pressure: " + str(profile["market_pressure"])
            ] + profile["recent_evidence"],
            "Marketing retention is sensitive to launch intensity and resourcing strain.",
            "Campaign capacity is " + ("stretched" if campaign_strain > 0.72 else "stable") + "."
        ),
        normalize_dimension(
            "visibility_and_growth",
            visibility,
            0.33,
            [
                "Brand visibility: " + str(profile["brand_visibility"]),
                "Recognition signal: " + str(profile["recognition_signal"]),
                "Mobility interest: " + profile["mobility_interest"]
            ],
            "Visible impact and advancement clarity improve retention for marketing leaders.",
            "Visibility and growth are " + ("mixed" if visibility < 0.65 else "healthy") + "."
        ),
        normalize_dimension(
            "reward_and_market_pressure",
            (reward_alignment + (1.0 - profile["market_pressure"])) / 2.0,
            0.33,
            [
                "Compa ratio: " + str(profile["compa_ratio"]),
                "Pipeline coverage: " + str(profile["pipeline_coverage"]),
                profile["flight_risk_note"]
            ],
            "External recruiter attention and perceived reward fairness influence marketing retention.",
            "Reward and market pressure are " + ("elevated" if profile["market_pressure"] > 0.7 else "contained") + "."
        )
    ];
    return {
        "role_family": "marketing",
        "dimensions": dimensions,
        "domain_summary": "Marketing evaluator emphasizes campaign capacity, visibility, and reward pressure."
    };
}

def derive_retention_score(profile: dict, normalized_dimensions: list) -> dict {
    total = 0.0;
    for dimension in normalized_dimensions {
        total = total + dimension["weighted_score"];
    }
    engagement_adjustment = (profile["engagement_signal"] - 0.5) * 0.2;
    tenure_adjustment = 0.03 if profile["tenure_years"] > 4.0 else 0.0;
    final_score = total + engagement_adjustment + tenure_adjustment;
    if final_score < 0.0 { final_score = 0.0; }
    if final_score > 1.0 { final_score = 1.0; }
    risk_band = "high" if final_score < 0.5 else "moderate" if final_score < 0.7 else "low";
    chain = build_chain(
        [
            "Weighted domain dimensions total: " + str(round(total, 3)),
            "Engagement signal: " + str(profile["engagement_signal"]),
            "Tenure years: " + str(profile["tenure_years"])
        ],
        "The derived score combines normalized domain dimensions with modest engagement and tenure adjustments for explainable decision support.",
        "Overall retention outlook is " + risk_band + " risk with score " + str(round(final_score, 3)) + "."
    );
    return {
        "retention_score": round(final_score, 3),
        "risk_band": risk_band,
        "explanation_chain": chain
    };
}

def build_pdf_ready_sections(profile: dict, evaluation: dict, scorecard: dict) -> list {
    return [
        {
            "section_title": "Executive Summary",
            "body": [
                profile["name"] + " is evaluated as a " + profile["role_family"] + " employee in a decision-support workflow.",
                "Retention score: " + str(scorecard["retention_score"]) + " with " + scorecard["risk_band"] + " risk band.",
                "Guardrail: outputs support retention planning and should not be used as sole basis for employment action."
            ]
        },
        {
            "section_title": "Normalized Dimensions",
            "body": [
                dimension["name"] + ": score=" + str(dimension["score"]) + ", interpretation=" + dimension["interpretation"]
                for dimension in evaluation["dimensions"]
            ]
        },
        {
            "section_title": "Evidence to Conclusion Chain",
            "body": [
                "Evidence: " + "; ".join(scorecard["explanation_chain"]["evidence"]),
                "Interpretation: " + scorecard["explanation_chain"]["interpretation"],
                "Conclusion: " + scorecard["explanation_chain"]["conclusion"]
            ]
        }
    ];
}

def build_ppt_ready_sections(profile: dict, evaluation: dict, scorecard: dict) -> list {
    return [
        {
            "slide_title": "Employee Snapshot",
            "bullets": [
                profile["name"] + " — " + profile["title"],
                "Team: " + profile["team"] + " | Manager: " + profile["manager"],
                "Location: " + profile["location"] + " | Tenure: " + str(profile["tenure_years"]) + " years"
            ]
        },
        {
            "slide_title": "Retention Drivers",
            "bullets": [
                dimension["name"] + " => " + dimension["conclusion"]
                for dimension in evaluation["dimensions"]
            ]
        },
        {
            "slide_title": "Recommended Discussion Focus",
            "bullets": [
                "Clarify growth path and role scope.",
                "Review workload and support balance.",
                "Validate reward competitiveness against market pressure.",
                "Guardrail: use as manager discussion input, not automated decision output."
            ]
        }
    ];
}

def build_console_summary(profile: dict, evaluation: dict, scorecard: dict) -> str {
    return "Retention decision-support report for " + profile["name"] + " (" + profile["employee_id"] + ") => score " + str(scorecard["retention_score"]) + ", risk " + scorecard["risk_band"] + ".";
}

def:pub get_mock_employees() -> list {
    return [
        {
            "employee_id": employee["employee_id"],
            "name": employee["name"],
            "role_family": employee["role_family"],
            "title": employee["title"],
            "team": employee["team"],
            "location": employee["location"]
        }
        for employee in mock_employees()
    ];
}

def:pub run_retention_evaluation(employee_id: str) -> dict {
    profile = find_mock_employee(employee_id);
    if not profile {
        return {
            "status": "not_found",
            "message": "No mock employee matched the provided identifier.",
            "guardrails": [
                "Decision-support only.",
                "Do not use this output as the sole basis for employment action."
            ]
        };
    }
    role_family = profile["role_family"];
    evaluation = engineering_evaluator(profile) if role_family == "engineering" else marketing_evaluator(profile);
    scorecard = derive_retention_score(profile, evaluation["dimensions"]);
    print(build_console_summary(profile, evaluation, scorecard));
    return {
        "status": "ok",
        "employee": {
            "employee_id": profile["employee_id"],
            "name": profile["name"],
            "role_family": profile["role_family"],
            "title": profile["title"],
            "team": profile["team"],
            "manager": profile["manager"],
            "location": profile["location"],
            "tenure_years": profile["tenure_years"],
            "level": profile["level"]
        },
        "orchestrator": {
            "selected_role_family": role_family,
            "selected_evaluator": role_family + "_evaluator",
            "domain_summary": evaluation["domain_summary"]
        },
        "normalized_dimensions": evaluation["dimensions"],
        "retention_score": scorecard["retention_score"],
        "risk_band": scorecard["risk_band"],
        "explanation_chain": scorecard["explanation_chain"],
        "console_report": build_console_summary(profile, evaluation, scorecard),
        "json_report": {
            "employee_id": profile["employee_id"],
            "retention_score": scorecard["retention_score"],
            "risk_band": scorecard["risk_band"],
            "dimensions": evaluation["dimensions"]
        },
        "pdf_ready_sections": build_pdf_ready_sections(profile, evaluation, scorecard),
        "ppt_ready_sections": build_ppt_ready_sections(profile, evaluation, scorecard),
        "guardrails": [
            "Decision-support only.",
            "Use alongside manager judgment, employee context, and HR review.",
            "Do not use as the sole basis for compensation, termination, or promotion decisions."
        ]
    };
}
