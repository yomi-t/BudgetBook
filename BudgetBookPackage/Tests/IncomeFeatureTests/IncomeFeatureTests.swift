import ComposableArchitecture
import Core
import IncomeFeature
import Testing

@MainActor
private struct IncomeFeatureTests {
    @Test(arguments: [
        [
            Income(source: "勤務先", year: 2025, month: 3, amount: 39232),
            Income(source: "勤務先", year: 2025, month: 4, amount: 58392)
        ],
        [
            Income(source: "hello", year: 2025, month: 2, amount: 48939),
            Income(source: "alksjd", year: 2025, month: 2, amount: 19293),
            Income(source: "sajnla", year: 2025, month: 3, amount: 64738),
            Income(source: "lasjdv", year: 2025, month: 4, amount: 39292)
        ]
    ])
    func testUpdateData(_ data: [Income]) async {
        let store = TestStore(initialState: IncomeReducer.State()) {
            IncomeReducer()
        }

        // テストストアの詳細検証を無効にする
        store.exhaustivity = .off
                
        await store.send(.updateData(data)) {
            $0.incomes = data
            $0.incomeListState.incomes = data.reversed()
        }
    }
}
