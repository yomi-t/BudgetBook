import Core
import Testing

private struct BalanceTests {
    struct YearMonthTestCase {
        let year: Int
        let month: Int
        let expected: String
    }

    @Test(arguments: [
        YearMonthTestCase(year: 2025, month: 3, expected: "3-2025"),
        YearMonthTestCase(year: 2024, month: 12, expected: "12-2024"),
        YearMonthTestCase(year: 2025, month: 1, expected: "1-2025"),
        YearMonthTestCase(year: 2026, month: 11, expected: "11-2026")
    ])
    func testYearMonthFormat(testCase: YearMonthTestCase) {
        let balance = Balance(
            account: "現金",
            year: testCase.year,
            month: testCase.month,
            amount: 100000
        )

        #expect(balance.yearMonth() == testCase.expected)
    }

    struct DisplayMonthTestCase {
        let year: Int
        let month: Int
        let expected: String
    }

    @Test(arguments: [
        DisplayMonthTestCase(year: 2025, month: 3, expected: "25/03"),
        DisplayMonthTestCase(year: 2025, month: 11, expected: "25/11"),
        DisplayMonthTestCase(year: 2024, month: 1, expected: "24/01"),
        DisplayMonthTestCase(year: 2024, month: 12, expected: "24/12"),
        DisplayMonthTestCase(year: 2000, month: 5, expected: "00/05"),
        DisplayMonthTestCase(year: 2100, month: 6, expected: "00/06"),
        DisplayMonthTestCase(year: 2099, month: 7, expected: "99/07")
    ])
    func testDisplayMonthFormat(testCase: DisplayMonthTestCase) {
        let balance = Balance(
            account: "現金",
            year: testCase.year,
            month: testCase.month,
            amount: 100000
        )

        #expect(balance.displayMonth() == testCase.expected)
    }

    struct InitTestCase {
        let account: String
        let year: Int
        let month: Int
        let amount: Int
    }

    @Test(arguments: [
        InitTestCase(account: "現金", year: 2025, month: 3, amount: 100000),
        InitTestCase(account: "銀行", year: 2024, month: 12, amount: 500000),
        InitTestCase(account: "証券", year: 2026, month: 1, amount: 0)
    ])
    func testInitWithoutId(testCase: InitTestCase) {
        let balance = Balance(
            account: testCase.account,
            year: testCase.year,
            month: testCase.month,
            amount: testCase.amount
        )

        #expect(!balance.id.isEmpty)
        #expect(balance.account == testCase.account)
        #expect(balance.year == testCase.year)
        #expect(balance.month == testCase.month)
        #expect(balance.amount == testCase.amount)
    }

    struct InitWithIdTestCase {
        let id: String
        let account: String
        let year: Int
        let month: Int
        let amount: Int
    }

    @Test(arguments: [
        InitWithIdTestCase(id: "test-id-1", account: "現金", year: 2025, month: 3, amount: 100000),
        InitWithIdTestCase(id: "test-id-2", account: "銀行", year: 2024, month: 12, amount: 500000),
        InitWithIdTestCase(id: "test-id-3", account: "証券", year: 2026, month: 1, amount: 0)
    ])
    func testInitWithId(testCase: InitWithIdTestCase) {
        let balance = Balance(
            id: testCase.id,
            account: testCase.account,
            year: testCase.year,
            month: testCase.month,
            amount: testCase.amount
        )

        #expect(balance.id == testCase.id)
        #expect(balance.account == testCase.account)
        #expect(balance.year == testCase.year)
        #expect(balance.month == testCase.month)
        #expect(balance.amount == testCase.amount)
    }

    @Test
    func testConvertToGraphDataGroupsByMonth() {
        let balances = [
            Balance(id: "1", account: "現金", year: 2025, month: 3, amount: 100000),
            Balance(id: "2", account: "銀行", year: 2025, month: 3, amount: 200000),
            Balance(id: "3", account: "現金", year: 2025, month: 4, amount: 150000)
        ]

        let graphData = balances.convertToGraphData()

        #expect(graphData.count == 2)
        let march = graphData.first { $0.yearMonth == "25/03" }
        let april = graphData.first { $0.yearMonth == "25/04" }
        #expect(march?.amount == 300000)
        #expect(april?.amount == 150000)
    }

    @Test
    func testConvertToGraphDataSingleItem() {
        let balances = [
            Balance(id: "1", account: "現金", year: 2025, month: 6, amount: 80000)
        ]

        let graphData = balances.convertToGraphData()

        #expect(graphData.count == 1)
        #expect(graphData[0].yearMonth == "25/06")
        #expect(graphData[0].amount == 80000)
    }

    @Test
    func testConvertToGraphDataEmpty() {
        let balances: [Balance] = []

        let graphData = balances.convertToGraphData()

        #expect(graphData.isEmpty)
    }

    @Test
    func testEquatable() {
        let balance1 = Balance(
            id: "same-id",
            account: "現金",
            year: 2025,
            month: 3,
            amount: 100000
        )

        let balance2 = Balance(
            id: "same-id",
            account: "現金",
            year: 2025,
            month: 3,
            amount: 100000
        )

        let balance3 = Balance(
            id: "different-id",
            account: "現金",
            year: 2025,
            month: 3,
            amount: 100000
        )

        #expect(balance1 == balance2)
        #expect(balance1 != balance3)
    }
}
