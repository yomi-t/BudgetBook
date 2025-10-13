import ComposableArchitecture
import HomeFeature
import SharedModel
import Testing

@MainActor
private struct HomeFeatureTests {
    @Test(arguments: [
        [Balance(account: "test", year: 2025, month: 8, amount: 83_929)],
        [Balance(account: "test", year: 2025, month: 8, amount: 83_929), Balance(account: "test2", year: 2025, month: 8, amount: 50_000)]
    ])
    func testUpdateBalances(_ balances: [Balance]) async {
        let store = TestStore(initialState: HomeReducer.State()) {
            HomeReducer()
        }
        
        // テストストアの詳細検証を無効にする
        store.exhaustivity = .off

        await store.send(.updateBalances(balances)) {
            $0.latestBalances = balances
            $0.latestMoney = balances.reduce(0) { $0 + $1.amount }
        }
    }
}
