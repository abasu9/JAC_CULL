import from services.hr_service { chat_query, load_mock_hr_graph }
import from services.retention_service { get_mock_employees, run_retention_evaluation, get_github_pat_status, get_github_activity }
cl import from .components.retentionDashboard { RetentionDashboard }
cl import ".styles.global.css";

cl def:pub app() -> JsxElement {
    return <RetentionDashboard />;
}
