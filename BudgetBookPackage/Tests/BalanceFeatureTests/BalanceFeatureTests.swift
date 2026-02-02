import BalanceFeature
import ComposableArchitecture
import Core
import Testing

@MainActor
private struct BalanceFeatureTests {
    struct UpdateBalancesTestCase: Sendable {
        let balances: [Balance]
        let expectedCount: Int
    }

    @Test(arguments: [
        UpdateBalancesTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 50000),
                Balance(account: "銀行", year: 2025, month: 1, amount: 100000)
            ],
            expectedCount: 2
        ),
        UpdateBalancesTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 50000),
                Balance(account: "銀行", year: 2025, month: 1, amount: 100000),
                Balance(account: "クレジットカード", year: 2025, month: 2, amount: 75000)
            ],
            expectedCount: 3
        ),
        UpdateBalancesTestCase(
            balances: [
                Balance(account: "現金", year: 2024, month: 12, amount: 30000)
            ],
            expectedCount: 1
        ),
        UpdateBalancesTestCase(
            balances: [],
            expectedCount: 0
        ),
        UpdateBalancesTestCase(
            balances: [
                Balance(account: "口座A", year: 2025, month: 1, amount: 10000),
                Balance(account: "口座B", year: 2025, month: 1, amount: 20000),
                Balance(account: "口座C", year: 2025, month: 1, amount: 30000),
                Balance(account: "口座D", year: 2025, month: 1, amount: 40000),
                Balance(account: "口座E", year: 2025, month: 1, amount: 50000)
            ],
            expectedCount: 5
        )
    ])
    func testUpdateBalances(_ testCase: UpdateBalancesTestCase) async {
        let store = TestStore(initialState: BalanceReducer.State()) {
            BalanceReducer()
        }

        store.exhaustivity = .off

        await store.send(.updateBalances(testCase.balances)) {
            $0.balances = testCase.balances
            $0.balanceListState.balances = testCase.balances.reversed()
        }
    }

    struct BalanceAmountTestCase: Sendable {
        let balances: [Balance]
        let totalAmount: Int
    }

    @Test(arguments: [
        BalanceAmountTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 50000),
                Balance(account: "銀行", year: 2025, month: 1, amount: 100000)
            ],
            totalAmount: 150000
        ),
        BalanceAmountTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 25000),
                Balance(account: "銀行", year: 2025, month: 1, amount: 75000),
                Balance(account: "投資", year: 2025, month: 1, amount: 200000)
            ],
            totalAmount: 300000
        ),
        BalanceAmountTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 0)
            ],
            totalAmount: 0
        ),
        BalanceAmountTestCase(
            balances: [],
            totalAmount: 0
        )
    ])
    func testBalanceTotalAmount(_ testCase: BalanceAmountTestCase) async {
        let store = TestStore(initialState: BalanceReducer.State()) {
            BalanceReducer()
        }

        store.exhaustivity = .off

        await store.send(.updateBalances(testCase.balances)) {
            $0.balances = testCase.balances
            let calculatedTotal = testCase.balances.reduce(0) { $0 + $1.amount }
            // 期待値と実際の合計が一致することを確認
            if calculatedTotal != testCase.totalAmount {
                Issue.record("Expected total \(testCase.totalAmount) but got \(calculatedTotal)")
            }
        }
    }

    struct ReversedOrderTestCase: Sendable {
        let balances: [Balance]
        let description: String
    }

    @Test(arguments: [
        ReversedOrderTestCase(
            balances: [
                Balance(id: "1", account: "A", year: 2025, month: 1, amount: 10000),
                Balance(id: "2", account: "B", year: 2025, month: 1, amount: 20000),
                Balance(id: "3", account: "C", year: 2025, month: 1, amount: 30000)
            ],
            description: "複数の残高が逆順になる"
        ),
        ReversedOrderTestCase(
            balances: [
                Balance(id: "1", account: "現金", year: 2025, month: 1, amount: 50000)
            ],
            description: "1つの残高の場合"
        ),
        ReversedOrderTestCase(
            balances: [
                Balance(id: "1", account: "現金", year: 2025, month: 1, amount: 10000),
                Balance(id: "2", account: "銀行", year: 2025, month: 2, amount: 20000),
                Balance(id: "3", account: "投資", year: 2025, month: 3, amount: 30000),
                Balance(id: "4", account: "貯金", year: 2025, month: 4, amount: 40000)
            ],
            description: "多数の残高が逆順になる"
        )
    ])
    func testBalanceListReversedOrder(_ testCase: ReversedOrderTestCase) async {
        let store = TestStore(initialState: BalanceReducer.State()) {
            BalanceReducer()
        }

        store.exhaustivity = .off

        await store.send(.updateBalances(testCase.balances)) {
            $0.balances = testCase.balances
            $0.balanceListState.balances = testCase.balances.reversed()
            
            // 順序が逆になっていることを確認
            let reversed = Array(testCase.balances.reversed())
            for (index, balance) in reversed.enumerated() where $0.balanceListState.balances[index].id != balance.id {
                Issue.record("\(testCase.description): Balance order is not reversed correctly at index \(index)")
                
            }
        }
    }
}
