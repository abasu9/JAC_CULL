import from services.hr_service { chat_query, load_mock_hr_graph }
cl import from .components.hrCopilotApp { HRCopilotApp }
cl import ".styles.global.css";

cl {
    def:pub app() -> JsxElement {
        return <HRCopilotApp />;
    }
}
