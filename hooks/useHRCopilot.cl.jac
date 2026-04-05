sv import from ..services.hr_service { chat_query, load_mock_hr_graph }

def:pub useHRCopilot() -> dict {
    has query: str = "Summarize Ava Patel";
    has loading: bool = False;
    has result: dict = {};
    has history: list = [];

    async can with entry {
        await load_mock_hr_graph();
        await runQuery(query);
    }

    def updateQuery(value: str) -> None {
        query = value;
    }

    async def runQuery(next_query: str) -> None {
        if not next_query {
            return;
        }
        loading = True;
        query = next_query;
        payload = await chat_query(next_query);
        result = payload if payload else {
            "mode": "error",
            "message": "No response returned by the HR copilot service."
        };
        history = [{"query": next_query, "result": result}] + history[:5];
        loading = False;
    }

    return {
        "query": query,
        "setQuery": updateQuery,
        "loading": loading,
        "result": result,
        "history": history,
        "runQuery": runQuery
    };
}
