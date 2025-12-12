import Core
import Testing

private struct IncomeTests {
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
        let income = Income(
            source: "給料",
            year: testCase.year,
            month: testCase.month,
            amount: 300000
        )

        #expect(income.yearMonth() == testCase.expected)
    }

    struct DisplayMonthTestCase {
        let year: Int
        let month: Int
        let expected: String
    }

    @Test(arguments: [
        DisplayMonthTestCase(year: 2025, month: 3, expected: "03/25"),
        DisplayMonthTestCase(year: 2025, month: 11, expected: "11/25"),
        DisplayMonthTestCase(year: 2024, month: 1, expected: "01/24"),
        DisplayMonthTestCase(year: 2024, month: 12, expected: "12/24"),
        DisplayMonthTestCase(year: 2000, month: 5, expected: "05/00"),
        DisplayMonthTestCase(year: 2100, month: 6, expected: "06/00"),
        DisplayMonthTestCase(year: 2099, month: 7, expected: "07/99")
    ])
    func testDisplayMonthFormat(testCase: DisplayMonthTestCase) {
        let income = Income(
            source: "給料",
            year: testCase.year,
            month: testCase.month,
            amount: 300000
        )

        #expect(income.displayMonth() == testCase.expected)
    }

    struct InitTestCase {
        let source: String
        let year: Int
        let month: Int
        let amount: Int
    }

    @Test(arguments: [
        InitTestCase(source: "給料", year: 2025, month: 3, amount: 300000),
        InitTestCase(source: "副業", year: 2024, month: 12, amount: 50000),
        InitTestCase(source: "投資", year: 2026, month: 1, amount: 100000)
    ])
    func testInitWithoutId(testCase: InitTestCase) {
        let income = Income(
            source: testCase.source,
            year: testCase.year,
            month: testCase.month,
            amount: testCase.amount
        )

        #expect(!income.id.isEmpty)
        #expect(income.source == testCase.source)
        #expect(income.year == testCase.year)
        #expect(income.month == testCase.month)
        #expect(income.amount == testCase.amount)
    }

    struct InitWithIdTestCase {
        let id: String
        let source: String
        let year: Int
        let month: Int
        let amount: Int
    }

    @Test(arguments: [
        InitWithIdTestCase(id: "test-id-1", source: "給料", year: 2025, month: 3, amount: 300000),
        InitWithIdTestCase(id: "test-id-2", source: "副業", year: 2024, month: 12, amount: 50000),
        InitWithIdTestCase(id: "test-id-3", source: "投資", year: 2026, month: 1, amount: 100000)
    ])
    func testInitWithId(testCase: InitWithIdTestCase) {
        let income = Income(
            id: testCase.id,
            source: testCase.source,
            year: testCase.year,
            month: testCase.month,
            amount: testCase.amount
        )

        #expect(income.id == testCase.id)
        #expect(income.source == testCase.source)
        #expect(income.year == testCase.year)
        #expect(income.month == testCase.month)
        #expect(income.amount == testCase.amount)
    }

    @Test
    func testConvertToGraphData() {
        let incomes = [
            Income(id: "1", source: "給料", year: 2025, month: 3, amount: 300000),
            Income(id: "2", source: "副業", year: 2025, month: 3, amount: 50000),
            Income(id: "3", source: "給料", year: 2025, month: 4, amount: 350000)
        ]

        let graphData = incomes.convertToGraphData()

        #expect(graphData.count == 2)
        #expect(graphData[0].yearMonth == "03/25")
        #expect(graphData[0].amount == 350000)
        #expect(graphData[1].yearMonth == "04/25")
        #expect(graphData[1].amount == 350000)
    }

    @Test
    func testConvertToGraphDataSortsCorrectly() {
        let incomes = [
            Income(id: "1", source: "給料", year: 2025, month: 5, amount: 100000),
            Income(id: "2", source: "給料", year: 2025, month: 3, amount: 200000),
            Income(id: "3", source: "給料", year: 2024, month: 12, amount: 150000)
        ]

        let graphData = incomes.convertToGraphData()

        #expect(graphData.count == 3)
        #expect(graphData[0].yearMonth == "05/25")
        #expect(graphData[1].yearMonth == "03/25")
        #expect(graphData[2].yearMonth == "12/24")
    }

    @Test
    func testEquatable() {
        let income1 = Income(
            id: "same-id",
            source: "給料",
            year: 2025,
            month: 3,
            amount: 300000
        )

        let income2 = Income(
            id: "same-id",
            source: "給料",
            year: 2025,
            month: 3,
            amount: 300000
        )

        let income3 = Income(
            id: "different-id",
            source: "給料",
            year: 2025,
            month: 3,
            amount: 300000
        )

        #expect(income1 == income2)
        #expect(income1 != income3)
    }
}
