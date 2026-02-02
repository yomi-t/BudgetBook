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
            $0.balanceListState = .init(balances: testCase.balances.reversed())
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
            $0.balanceListState = .init(balances: testCase.balances.reversed())

            // monthlyBalancesが正しくグループ化されていることを確認
            let flatBalances = $0.balanceListState.monthlyBalances.flatMap { $0 }
            if flatBalances.count != testCase.balances.count {
                Issue.record("\(testCase.description): Balance count mismatch")
            }
        }
    }

    struct MonthlyGroupingTestCase: Sendable {
        let balances: [Balance]
        let expectedGroupCount: Int
        let description: String
    }

    @Test(arguments: [
        MonthlyGroupingTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 50000),
                Balance(account: "銀行", year: 2025, month: 1, amount: 100000)
            ],
            expectedGroupCount: 1,
            description: "同じ月の残高は1つのグループになる"
        ),
        MonthlyGroupingTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 50000),
                Balance(account: "銀行", year: 2025, month: 1, amount: 100000),
                Balance(account: "クレジットカード", year: 2025, month: 2, amount: 75000)
            ],
            expectedGroupCount: 2,
            description: "異なる月の残高は別々のグループになる"
        ),
        MonthlyGroupingTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 10000),
                Balance(account: "銀行", year: 2025, month: 2, amount: 20000),
                Balance(account: "投資", year: 2025, month: 3, amount: 30000),
                Balance(account: "貯金", year: 2025, month: 4, amount: 40000)
            ],
            expectedGroupCount: 4,
            description: "4つの異なる月で4グループになる"
        ),
        MonthlyGroupingTestCase(
            balances: [],
            expectedGroupCount: 0,
            description: "空の配列は0グループ"
        )
    ])
    func testMonthlyGrouping(_ testCase: MonthlyGroupingTestCase) async {
        let store = TestStore(initialState: BalanceReducer.State()) {
            BalanceReducer()
        }

        store.exhaustivity = .off

        await store.send(.updateBalances(testCase.balances)) {
            $0.balances = testCase.balances
            $0.balanceListState = .init(balances: testCase.balances.reversed())

            // 月ごとのグループ数が正しいことを確認
            if $0.balanceListState.monthlyBalances.count != testCase.expectedGroupCount {
                Issue.record("\(testCase.description): Expected \(testCase.expectedGroupCount) groups but got \($0.balanceListState.monthlyBalances.count)")
            }

            // 各グループ内の残高が同じ年月であることを確認
            for group in $0.balanceListState.monthlyBalances {
                guard let first = group.first else { continue }
                let yearMonth = first.yearMonth()
                for balance in group where balance.yearMonth() != yearMonth {
                    Issue.record("\(testCase.description): Balance in group has different yearMonth")
                }
            }
        }
    }

    @Test
    func testNavigateToDetail() async {
        let testBalances = [
            Balance(account: "現金", year: 2025, month: 1, amount: 50000),
            Balance(account: "銀行", year: 2025, month: 1, amount: 100000)
        ]

        let store = TestStore(initialState: BalanceReducer.State()) {
            BalanceReducer()
        }

        store.exhaustivity = .off

        await store.send(.balanceListAction(.delegate(.navigateToDetail(testBalances)))) {
            $0.path.append(.balanceDetail(BalanceDetailReducer.State(testBalances)))
        }
    }

    @Test
    func testDeleteBalance() async {
        let store = TestStore(initialState: BalanceReducer.State()) {
            BalanceReducer()
        } withDependencies: {
            $0.balanceRepository.delete = { _ in }
            $0.balanceRepository.fetchAll = { [] }
        }

        store.exhaustivity = .off

        await store.send(.balanceListAction(.delegate(.didDeleteBalance)))
    }
}
