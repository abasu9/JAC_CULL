sv import from ..services.retention_service { get_mock_employees, run_retention_evaluation }
import from "@jac/runtime" { jacIsLoggedIn }

def:pub useRetentionDashboard() -> dict {
    has employees: list = [];
    has selected_employee_id: str = "E-1001";
    has loading: bool = True;
    has running: bool = False;
    has result: dict = {};
    has error: str = "";
    has is_logged_in: bool = False;

    async can with entry {
        is_logged_in = jacIsLoggedIn();
        if not is_logged_in {
            loading = False;
            return;
        }
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
        if not jacIsLoggedIn() or not selected_employee_id {
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
        "is_logged_in": is_logged_in,
        "runEvaluation": runEvaluation
    };
}
