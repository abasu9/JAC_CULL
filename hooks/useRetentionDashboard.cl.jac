sv import from ..services.retention_service { get_mock_employees, run_retention_evaluation }

def:pub useRetentionDashboard() -> dict {
    has employees: list = [];
    has selected_employee_id: str = "E-1001";
    has loading: bool = True;
    has running: bool = False;
    has result: dict = {};
    has error: str = "";

    async can with entry {
        try {
            employees = await get_mock_employees() or [];
            if len(employees) > 0 and employees[0] and "employee_id" in employees[0] {
                selected_employee_id = employees[0]["employee_id"];
                result = await run_retention_evaluation(selected_employee_id) or {};
            }
        } except Exception as e {
            error = str(e);
        }
        loading = False;
    }

    def setSelectedEmployee(value: str) -> None {
        selected_employee_id = value;
    }

    async def runEvaluation() -> None {
        if not selected_employee_id {
            return;
        }
        running = True;
        error = "";
        try {
            result = await run_retention_evaluation(selected_employee_id) or {};
        } except Exception as e {
            error = str(e);
        }
        running = False;
    }

    return {
        "employees": employees,
        "selected_employee_id": selected_employee_id,
        "setSelectedEmployee": setSelectedEmployee,
        "loading": loading,
        "running": running,
        "result": result,
        "error": error,
        "runEvaluation": runEvaluation
    };
}
