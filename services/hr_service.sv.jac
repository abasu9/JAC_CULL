"""Mock HR insights backend service for an agentic copilot demo."""

node Employee {
    has employee_id: str = "";
    has name: str = "";
    has title: str = "";
    has team: str = "";
    has manager: str = "";
    has location: str = "";
    has tenure_years: float = 0.0;
    has level: str = "";
    has status: str = "active";
}

node APRRecord {
    has employee_id: str = "";
    has cycle: str = "";
    has rating: str = "";
    has highlights: str = "";
    has growth_areas: str = "";
}

node PIPRecord {
    has employee_id: str = "";
    has cycle: str = "";
    has status: str = "";
    has notes: str = "";
}

node CompensationRecord {
    has employee_id: str = "";
    has cycle: str = "";
    has base_salary: int = 0;
    has bonus_pct: float = 0.0;
    has equity_band: str = "";
    has compa_ratio: float = 0.0;
}

node ContributionRecord {
    has employee_id: str = "";
    has cycle: str = "";
    has impact_area: str = "";
    has summary: str = "";
    has impact_score: float = 0.0;
}

node SummaryRecord {
    has employee_id: str = "";
    has summary_type: str = "";
    has content: str = "";
    has caution: str = "Avoid using this summary for termination or retention recommendations.";
}

node DataGapRecord {
    has employee_id: str = "";
    has gap_type: str = "";
    has severity: str = "low";
    has detail: str = "";
}

def employee_to_dict(emp: Employee) -> dict {
    return {
        "jid": jid(emp),
        "employee_id": emp.employee_id,
        "name": emp.name,
        "title": emp.title,
        "team": emp.team,
        "manager": emp.manager,
        "location": emp.location,
        "tenure_years": emp.tenure_years,
        "level": emp.level,
        "status": emp.status
    };
}

def apr_to_dict(rec: APRRecord) -> dict {
    return {
        "cycle": rec.cycle,
        "rating": rec.rating,
        "highlights": rec.highlights,
        "growth_areas": rec.growth_areas
    };
}

def pip_to_dict(rec: PIPRecord) -> dict {
    return {
        "cycle": rec.cycle,
        "status": rec.status,
        "notes": rec.notes
    };
}

def compensation_to_dict(rec: CompensationRecord) -> dict {
    return {
        "cycle": rec.cycle,
        "base_salary": rec.base_salary,
        "bonus_pct": rec.bonus_pct,
        "equity_band": rec.equity_band,
        "compa_ratio": rec.compa_ratio
    };
}

def contribution_to_dict(rec: ContributionRecord) -> dict {
    return {
        "cycle": rec.cycle,
        "impact_area": rec.impact_area,
        "summary": rec.summary,
        "impact_score": rec.impact_score
    };
}

def summary_to_dict(rec: SummaryRecord) -> dict {
    return {
        "summary_type": rec.summary_type,
        "content": rec.content,
        "caution": rec.caution
    };
}

def data_gap_to_dict(rec: DataGapRecord) -> dict {
    return {
        "gap_type": rec.gap_type,
        "severity": rec.severity,
        "detail": rec.detail
    };
}

def find_employee_by_name_or_id(query: str) -> Employee {
    lowered = query.lower();
    for emp in [root()-->][?:Employee] {
        if emp.employee_id.lower() == lowered or emp.name.lower() == lowered {
            return emp;
        }
        if lowered in emp.name.lower() {
            return emp;
        }
    }
}

def fetch_employee_profile(employee_ref: str) -> dict {
    emp = find_employee_by_name_or_id(employee_ref);
    if not emp {
        return {"found": False, "employee_ref": employee_ref};
    }
    return {"found": True, "employee": employee_to_dict(emp)};
}

def fetch_apr_history(employee_ref: str) -> list {
    emp = find_employee_by_name_or_id(employee_ref);
    if not emp {
        return [];
    }
    return [apr_to_dict(rec) for rec in [emp-->][?:APRRecord]];
}

def fetch_pip_history(employee_ref: str) -> list {
    emp = find_employee_by_name_or_id(employee_ref);
    if not emp {
        return [];
    }
    return [pip_to_dict(rec) for rec in [emp-->][?:PIPRecord]];
}

def fetch_compensation(employee_ref: str) -> list {
    emp = find_employee_by_name_or_id(employee_ref);
    if not emp {
        return [];
    }
    return [compensation_to_dict(rec) for rec in [emp-->][?:CompensationRecord]];
}

def fetch_tenure(employee_ref: str) -> dict {
    emp = find_employee_by_name_or_id(employee_ref);
    if not emp {
        return {"found": False, "tenure_years": 0.0};
    }
    return {
        "found": True,
        "employee_id": emp.employee_id,
        "name": emp.name,
        "tenure_years": emp.tenure_years
    };
}

def fetch_contributions(employee_ref: str) -> list {
    emp = find_employee_by_name_or_id(employee_ref);
    if not emp {
        return [];
    }
    return [contribution_to_dict(rec) for rec in [emp-->][?:ContributionRecord]];
}

def detect_data_gaps(employee_ref: str) -> list {
    emp = find_employee_by_name_or_id(employee_ref);
    if not emp {
        return [{"gap_type": "employee_not_found", "severity": "high", "detail": "No employee matched the provided reference."}];
    }
    gaps = [data_gap_to_dict(rec) for rec in [emp-->][?:DataGapRecord]];
    if not [emp-->][?:APRRecord] {
        gaps.append({"gap_type": "missing_apr", "severity": "medium", "detail": "No APR records available."});
    }
    if not [emp-->][?:CompensationRecord] {
        gaps.append({"gap_type": "missing_compensation", "severity": "medium", "detail": "No compensation records available."});
    }
    if not [emp-->][?:ContributionRecord] {
        gaps.append({"gap_type": "missing_contributions", "severity": "medium", "detail": "No contribution records available."});
    }
    return gaps;
}

def prepare_employee_context(employee_ref: str) -> dict {
    profile = fetch_employee_profile(employee_ref);
    if not profile["found"] {
        return {
            "found": False,
            "employee_ref": employee_ref,
            "message": "No employee matched the provided reference."
        };
    }
    return {
        "found": True,
        "employee": profile["employee"],
        "apr_history": fetch_apr_history(employee_ref),
        "pip_history": fetch_pip_history(employee_ref),
        "compensation": fetch_compensation(employee_ref),
        "tenure": fetch_tenure(employee_ref),
        "contributions": fetch_contributions(employee_ref),
        "data_gaps": detect_data_gaps(employee_ref)
    };
}

def summarize_employee_context(employee_ref: str) -> dict {
    context = prepare_employee_context(employee_ref);
    if not context["found"] {
        return {
            "mode": "employee_summary",
            "found": False,
            "message": context["message"],
            "guardrail": "This copilot provides neutral summaries only and does not make termination or retention recommendations."
        };
    }
    employee = context["employee"];
    apr_history = context["apr_history"];
    latest_apr = apr_history[-1] if apr_history else {};
    latest_comp = context["compensation"][-1] if context["compensation"] else {};
    contribution_count = len(context["contributions"]);
    pip_count = len(context["pip_history"]);
    summary_text = employee["name"] + " is a " + employee["title"] + " on " + employee["team"] + ". Latest APR rating: " + (latest_apr["rating"] if latest_apr else "not available") + ". Contributions logged: " + str(contribution_count) + ".";
    return {
        "mode": "employee_summary",
        "found": True,
        "employee": employee,
        "summary": {
            "headline": summary_text,
            "latest_apr": latest_apr,
            "latest_compensation": latest_comp,
            "pip_history_count": pip_count,
            "data_gap_count": len(context["data_gaps"])
        },
        "data_gaps": context["data_gaps"],
        "guardrail": "Neutral HR insight only. Do not use this output for termination or retention recommendations."
    };
}

def summarize_team_context(team_name: str) -> dict {
    members = [emp for emp in [root()-->][?:Employee] if emp.team.lower() == team_name.lower()];
    if not members {
        return {
            "mode": "team_summary",
            "team": team_name,
            "member_count": 0,
            "message": "No team matched the provided name.",
            "guardrail": "Neutral HR insight only. Do not use this output for termination or retention recommendations."
        };
    }
    total_tenure = 0.0;
    top_member = "";
    top_score = -1.0;
    member_summaries = [];
    for emp in members {
        total_tenure = total_tenure + emp.tenure_years;
        contributions = [rec for rec in [emp-->][?:ContributionRecord]];
        score = 0.0;
        for rec in contributions {
            score = score + rec.impact_score;
        }
        if score > top_score {
            top_score = score;
            top_member = emp.name;
        }
        member_summaries.append({
            "employee_id": emp.employee_id,
            "name": emp.name,
            "title": emp.title,
            "tenure_years": emp.tenure_years,
            "contribution_score": score,
            "data_gap_count": len(detect_data_gaps(emp.employee_id))
        });
    }
    return {
        "mode": "team_summary",
        "team": team_name,
        "member_count": len(members),
        "average_tenure_years": total_tenure / len(members),
        "top_contributor_by_logged_impact": top_member,
        "members": member_summaries,
        "guardrail": "Neutral HR insight only. Do not use this output for termination or retention recommendations."
    };
}

def ensure_mock_graph() -> dict {
    existing = [root()-->][?:Employee];
    if existing {
        return {
            "loaded": False,
            "employee_count": len(existing),
            "message": "Mock HR graph already present."
        };
    }

    ava = (root() ++> Employee(employee_id="E1001", name="Ava Patel", title="Senior Software Engineer", team="Platform", manager="Nina Shah", location="Austin", tenure_years=4.2, level="L4"))[0];
    ava ++> APRRecord(employee_id="E1001", cycle="2023", rating="Exceeds", highlights="Led platform reliability improvements.", growth_areas="Delegate roadmap communication more broadly.");
    ava ++> APRRecord(employee_id="E1001", cycle="2024", rating="Strong", highlights="Delivered migration milestones on time.", growth_areas="Expand mentoring reach across teams.");
    ava ++> CompensationRecord(employee_id="E1001", cycle="2024", base_salary=168000, bonus_pct=12.5, equity_band="B", compa_ratio=0.98);
    ava ++> ContributionRecord(employee_id="E1001", cycle="2024-H1", impact_area="Reliability", summary="Reduced Sev-1 incidents through service hardening.", impact_score=8.8);
    ava ++> ContributionRecord(employee_id="E1001", cycle="2024-H2", impact_area="Migration", summary="Coordinated backend migration with low disruption.", impact_score=8.4);
    ava ++> SummaryRecord(employee_id="E1001", summary_type="manager_note", content="Consistent delivery with strong cross-functional trust.");

    liam = (root() ++> Employee(employee_id="E1002", name="Liam Chen", title="Product Analyst", team="Platform", manager="Nina Shah", location="Seattle", tenure_years=2.6, level="L3"))[0];
    liam ++> APRRecord(employee_id="E1002", cycle="2024", rating="Strong", highlights="Improved KPI instrumentation for platform launches.", growth_areas="Increase executive-ready storytelling.");
    liam ++> CompensationRecord(employee_id="E1002", cycle="2024", base_salary=121000, bonus_pct=10.0, equity_band="A", compa_ratio=1.01);
    liam ++> ContributionRecord(employee_id="E1002", cycle="2024-H2", impact_area="Analytics", summary="Built adoption dashboard used in quarterly reviews.", impact_score=7.9);
    liam ++> DataGapRecord(employee_id="E1002", gap_type="missing_pip_history", severity="low", detail="No PIP history on file, which may simply indicate none exists.");

    sofia = (root() ++> Employee(employee_id="E1003", name="Sofia Ramirez", title="Engineering Manager", team="Applications", manager="Marcus Lee", location="New York", tenure_years=6.8, level="M1"))[0];
    sofia ++> APRRecord(employee_id="E1003", cycle="2023", rating="Strong", highlights="Stabilized delivery cadence across two squads.", growth_areas="Clarify long-term architecture tradeoffs earlier.");
    sofia ++> APRRecord(employee_id="E1003", cycle="2024", rating="Exceeds", highlights="Improved engagement and launch predictability.", growth_areas="Continue succession planning.");
    sofia ++> CompensationRecord(employee_id="E1003", cycle="2024", base_salary=196000, bonus_pct=15.0, equity_band="C", compa_ratio=1.04);
    sofia ++> ContributionRecord(employee_id="E1003", cycle="2024-H1", impact_area="Leadership", summary="Raised planning quality and reduced spillover work.", impact_score=9.1);
    sofia ++> ContributionRecord(employee_id="E1003", cycle="2024-H2", impact_area="Coaching", summary="Mentored new leads and improved onboarding outcomes.", impact_score=8.7);
    sofia ++> SummaryRecord(employee_id="E1003", summary_type="peer_note", content="Trusted people leader with strong execution discipline.");

    noah = (root() ++> Employee(employee_id="E1004", name="Noah Brooks", title="Customer Success Manager", team="Applications", manager="Marcus Lee", location="Chicago", tenure_years=1.4, level="L2"))[0];
    noah ++> APRRecord(employee_id="E1004", cycle="2024", rating="Developing", highlights="Built stronger customer follow-up routines.", growth_areas="Improve escalation documentation consistency.");
    noah ++> PIPRecord(employee_id="E1004", cycle="2024-Q2", status="completed", notes="Structured support plan focused on case hygiene and response consistency.");
    noah ++> CompensationRecord(employee_id="E1004", cycle="2024", base_salary=94000, bonus_pct=8.0, equity_band="A", compa_ratio=0.95);
    noah ++> ContributionRecord(employee_id="E1004", cycle="2024-H2", impact_area="Customer Operations", summary="Improved renewal prep process for key accounts.", impact_score=6.8);
    noah ++> DataGapRecord(employee_id="E1004", gap_type="limited_contribution_history", severity="medium", detail="Only one recent contribution record is available.");

    maya = (root() ++> Employee(employee_id="E1005", name="Maya Singh", title="Staff Data Scientist", team="People Analytics", manager="Elena Park", location="San Francisco", tenure_years=5.1, level="L5"))[0];
    maya ++> APRRecord(employee_id="E1005", cycle="2024", rating="Exceeds", highlights="Built workforce planning model adopted by HRBPs.", growth_areas="Document model assumptions for broader reuse.");
    maya ++> CompensationRecord(employee_id="E1005", cycle="2024", base_salary=214000, bonus_pct=16.0, equity_band="C", compa_ratio=1.02);
    maya ++> ContributionRecord(employee_id="E1005", cycle="2024-H1", impact_area="Modeling", summary="Created attrition risk segmentation for planning use.", impact_score=9.4);
    maya ++> ContributionRecord(employee_id="E1005", cycle="2024-H2", impact_area="Insights", summary="Delivered compensation equity analysis for annual planning.", impact_score=9.0);
    maya ++> SummaryRecord(employee_id="E1005", summary_type="hrbp_note", content="High analytical leverage with strong stakeholder trust.");

    return {
        "loaded": True,
        "employee_count": len([root()-->][?:Employee]),
        "message": "Mock HR graph loaded."
    };
}

def:pub load_mock_hr_graph -> dict {
    return ensure_mock_graph();
}

walker :pub EmployeeSummaryWalker {
    has employee_ref: str = "";

    can summarize with Root entry {
        report summarize_employee_context(self.employee_ref);
    }
}

walker :pub TopContributorsWalker {
    has team: str = "";
    has limit: int = 3;

    can rank with Root entry {
        members = [emp for emp in [-->][?:Employee] if (not self.team) or emp.team.lower() == self.team.lower()];
        scored = [];
        for emp in members {
            total_score = 0.0;
            for rec in [emp-->][?:ContributionRecord] {
                total_score = total_score + rec.impact_score;
            }
            scored.append({
                "employee": employee_to_dict(emp),
                "total_impact_score": total_score,
                "contribution_count": len([emp-->][?:ContributionRecord])
            });
        }
        scored = sorted(scored, key=lambda item: item["total_impact_score"], reverse=True);
        report {
            "mode": "top_contributors",
            "team": self.team if self.team else "all",
            "results": scored[:self.limit],
            "guardrail": "Neutral HR insight only. Do not use this output for termination or retention recommendations."
        };
    }
}

walker :pub DataGapCheckWalker {
    has employee_ref: str = "";

    can inspect with Root entry {
        report {
            "mode": "data_gap_check",
            "employee_ref": self.employee_ref,
            "data_gaps": detect_data_gaps(self.employee_ref),
            "guardrail": "Neutral HR insight only. Do not use this output for termination or retention recommendations."
        };
    }
}

walker :pub TeamReviewWalker {
    has team: str = "";

    can review with Root entry {
        report summarize_team_context(self.team);
    }
}

walker :pub RankingPreparationWalker {
    has team: str = "";

    can prepare with Root entry {
        members = [emp for emp in [-->][?:Employee] if (not self.team) or emp.team.lower() == self.team.lower()];
        ranking_rows = [];
        for emp in members {
            aprs = [apr_to_dict(rec) for rec in [emp-->][?:APRRecord]];
            latest_apr = aprs[-1] if aprs else {};
            total_score = 0.0;
            for rec in [emp-->][?:ContributionRecord] {
                total_score = total_score + rec.impact_score;
            }
            ranking_rows.append({
                "employee": employee_to_dict(emp),
                "latest_apr_rating": latest_apr["rating"] if latest_apr else "not available",
                "total_logged_impact": total_score,
                "data_gap_count": len(detect_data_gaps(emp.employee_id)),
                "note": "Use as preparation input only; avoid employment action recommendations."
            });
        }
        ranking_rows = sorted(ranking_rows, key=lambda item: item["total_logged_impact"], reverse=True);
        report {
            "mode": "ranking_preparation",
            "team": self.team if self.team else "all",
            "rows": ranking_rows,
            "guardrail": "Preparation support only. Do not use this output for termination or retention recommendations."
        };
    }
}

walker :pub QueryRouterWalker {
    has query: str = "";

    can route with Root entry {
        ensure_mock_graph();
        lowered = self.query.lower();

        if "top contributor" in lowered or "top contributors" in lowered {
            team_name = "";
            for emp in [-->][?:Employee] {
                if emp.team.lower() in lowered {
                    team_name = emp.team;
                    break;
                }
            }
            visit TopContributorsWalker(team=team_name);
            return;
        }

        if "data gap" in lowered or "missing data" in lowered {
            for emp in [-->][?:Employee] {
                if emp.name.lower() in lowered or emp.employee_id.lower() in lowered {
                    visit DataGapCheckWalker(employee_ref=emp.employee_id);
                    return;
                }
            }
        }

        if "team review" in lowered or "team summary" in lowered {
            for emp in [-->][?:Employee] {
                if emp.team.lower() in lowered {
                    visit TeamReviewWalker(team=emp.team);
                    return;
                }
            }
        }

        if "ranking" in lowered or "calibration" in lowered {
            for emp in [-->][?:Employee] {
                if emp.team.lower() in lowered {
                    visit RankingPreparationWalker(team=emp.team);
                    return;
                }
            }
            visit RankingPreparationWalker();
            return;
        }

        for emp in [-->][?:Employee] {
            if emp.name.lower() in lowered or emp.employee_id.lower() in lowered {
                visit EmployeeSummaryWalker(employee_ref=emp.employee_id);
                return;
            }
        }

        report {
            "mode": "router_fallback",
            "query": self.query,
            "message": "Try asking for an employee summary, top contributors, data gaps, team review, or ranking preparation.",
            "available_employees": [employee_to_dict(emp) for emp in [-->][?:Employee]],
            "guardrail": "Neutral HR insight only. Do not use this output for termination or retention recommendations."
        };
    }
}

def:pub chat_query(query: str) -> dict {
    ensure_mock_graph();
    lowered = query.lower();

    if "top contributor" in lowered or "top contributors" in lowered {
        team_name = "";
        for emp in [root()-->][?:Employee] {
            if emp.team.lower() in lowered {
                team_name = emp.team;
                break;
            }
        }
        return {
            "mode": "top_contributors",
            "query": query,
            "result": TopContributorsWalker(team=team_name).spawn(root()),
            "guardrail": "Neutral HR insight only. Do not use this output for termination or retention recommendations."
        };
    }

    if "data gap" in lowered or "missing data" in lowered {
        for emp in [root()-->][?:Employee] {
            if emp.name.lower() in lowered or emp.employee_id.lower() in lowered {
                return {
                    "mode": "data_gap_check",
                    "query": query,
                    "result": detect_data_gaps(emp.employee_id),
                    "guardrail": "Neutral HR insight only. Do not use this output for termination or retention recommendations."
                };
            }
        }
    }

    if "team review" in lowered or "team summary" in lowered {
        for emp in [root()-->][?:Employee] {
            if emp.team.lower() in lowered {
                return summarize_team_context(emp.team);
            }
        }
    }

    if "ranking" in lowered or "calibration" in lowered {
        team_name = "";
        for emp in [root()-->][?:Employee] {
            if emp.team.lower() in lowered {
                team_name = emp.team;
                break;
            }
        }
        members = [emp for emp in [root()-->][?:Employee] if (not team_name) or emp.team == team_name];
        rows = [];
        for emp in members {
            total_score = 0.0;
            for rec in [emp-->][?:ContributionRecord] {
                total_score = total_score + rec.impact_score;
            }
            aprs = [apr_to_dict(rec) for rec in [emp-->][?:APRRecord]];
            latest_apr = aprs[-1] if aprs else {};
            rows.append({
                "employee": employee_to_dict(emp),
                "latest_apr_rating": latest_apr["rating"] if latest_apr else "not available",
                "total_logged_impact": total_score,
                "data_gap_count": len(detect_data_gaps(emp.employee_id)),
                "note": "Use as preparation input only; avoid employment action recommendations."
            });
        }
        rows = sorted(rows, key=lambda item: item["total_logged_impact"], reverse=True);
        return {
            "mode": "ranking_preparation",
            "team": team_name if team_name else "all",
            "rows": rows,
            "guardrail": "Preparation support only. Do not use this output for termination or retention recommendations."
        };
    }

    for emp in [root()-->][?:Employee] {
        if emp.name.lower() in lowered or emp.employee_id.lower() in lowered {
            return summarize_employee_context(emp.employee_id);
        }
    }

    return {
        "mode": "router_fallback",
        "query": query,
        "message": "Try asking for an employee summary, top contributors, data gaps, team review, or ranking preparation.",
        "available_employees": [employee_to_dict(emp) for emp in [root()-->][?:Employee]],
        "guardrail": "Neutral HR insight only. Do not use this output for termination or retention recommendations."
    };
}
