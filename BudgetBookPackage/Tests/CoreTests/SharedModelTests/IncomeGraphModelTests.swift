import Core
import Testing

private struct IncomeGraphModelTests {
    @Test(arguments: [
        IncomeGraphModel(
            id: "test-id",
            yearMonth: "25/03",
            amount: 300000
        )
    ])
    func testInitWithParameters(_ model: IncomeGraphModel) {
        #expect(model.id == "test-id")
        #expect(model.yearMonth == "25/03")
        #expect(model.amount == 300000)
    }

    struct InitFromIncomeTestCase {
        let year: Int
        let month: Int
        let expectedYearMonth: String
    }

    @Test(arguments: [
        InitFromIncomeTestCase(year: 2025, month: 3, expectedYearMonth: "25/03"),
        InitFromIncomeTestCase(year: 2024, month: 12, expectedYearMonth: "24/12"),
        InitFromIncomeTestCase(year: 2025, month: 1, expectedYearMonth: "25/01"),
        InitFromIncomeTestCase(year: 2000, month: 6, expectedYearMonth: "00/06"),
        InitFromIncomeTestCase(year: 2099, month: 7, expectedYearMonth: "99/07")
    ])
    func testInitFromIncome(testCase: InitFromIncomeTestCase) {
        let income = Income(
            id: "income-id",
            source: "給料",
            year: testCase.year,
            month: testCase.month,
            amount: 300000
        )

        let model = IncomeGraphModel(income)

        #expect(model.yearMonth == testCase.expectedYearMonth)
    }

    struct YearExtractionTestCase {
        let yearMonth: String
        let expectedYear: Int
    }

    @Test(arguments: [
        YearExtractionTestCase(yearMonth: "03-25", expectedYear: 25),
        YearExtractionTestCase(yearMonth: "11-24", expectedYear: 24),
        YearExtractionTestCase(yearMonth: "01-00", expectedYear: 0),
        YearExtractionTestCase(yearMonth: "12-99", expectedYear: 99)
    ])
    func testYearExtraction(testCase: YearExtractionTestCase) {
        let model = IncomeGraphModel(
            id: "test-id",
            yearMonth: testCase.yearMonth,
            amount: 300000
        )

        #expect(model.year() == testCase.expectedYear)
    }

    struct MonthExtractionTestCase {
        let yearMonth: String
        let expectedMonth: Int
    }

    @Test(arguments: [
        MonthExtractionTestCase(yearMonth: "03-25", expectedMonth: 3),
        MonthExtractionTestCase(yearMonth: "11-24", expectedMonth: 11),
        MonthExtractionTestCase(yearMonth: "01-00", expectedMonth: 1),
        MonthExtractionTestCase(yearMonth: "12-99", expectedMonth: 12)
    ])
    func testMonthExtraction(testCase: MonthExtractionTestCase) {
        let model = IncomeGraphModel(
            id: "test-id",
            yearMonth: testCase.yearMonth,
            amount: 300000
        )

        #expect(model.month() == testCase.expectedMonth)
    }

    struct SortByMonthTestCase {
        let input: [String]
        let expected: [String]
    }

    @Test(arguments: [
        SortByMonthTestCase(
            input: ["05-25", "03-25", "12-24", "01-26"],
            expected: ["12-24", "03-25", "05-25", "01-26"]
        ),
        SortByMonthTestCase(
            input: ["05-25", "01-25", "03-25"],
            expected: ["01-25", "03-25", "05-25"]
        ),
        SortByMonthTestCase(
            input: ["12-25", "01-25", "06-24", "03-26"],
            expected: ["06-24", "01-25", "12-25", "03-26"]
        )
    ])
    func testSortByMonth(testCase: SortByMonthTestCase) {
        let models = testCase.input.enumerated().map { index, yearMonth in
            IncomeGraphModel(
                id: "\(index)",
                yearMonth: yearMonth,
                amount: 100000
            )
        }

        let sorted = models.sortByMonth()

        #expect(sorted.count == testCase.expected.count)
        for (index, expectedYearMonth) in testCase.expected.enumerated() {
            #expect(sorted[index].yearMonth == expectedYearMonth)
        }
    }

    struct RangeAmountTestCase {
        let amounts: [Int]
        let expectedLower: Int
        let expectedUpper: Int
    }

    @Test(arguments: [
        RangeAmountTestCase(amounts: [100000, 300000, 200000], expectedLower: 0, expectedUpper: 310000),
        RangeAmountTestCase(amounts: [5000, 8000], expectedLower: 0, expectedUpper: 18000),
        RangeAmountTestCase(amounts: [50000], expectedLower: 0, expectedUpper: 60000),
        RangeAmountTestCase(amounts: [], expectedLower: 0, expectedUpper: 10000)
    ])
    func testRangeAmount(testCase: RangeAmountTestCase) {
        let models = testCase.amounts.enumerated().map { index, amount in
            IncomeGraphModel(
                id: "\(index)",
                yearMonth: "03/25",
                amount: amount
            )
        }

        let range = models.rangeAmount()

        #expect(range.lowerBound == testCase.expectedLower)
        #expect(range.upperBound == testCase.expectedUpper)
    }

    @Test
    func testEquatable() {
        let model1 = IncomeGraphModel(
            id: "same-id",
            yearMonth: "03/25",
            amount: 300000
        )

        let model2 = IncomeGraphModel(
            id: "same-id",
            yearMonth: "03/25",
            amount: 300000
        )

        let model3 = IncomeGraphModel(
            id: "different-id",
            yearMonth: "03/25",
            amount: 300000
        )

        #expect(model1 == model2)
        #expect(model1 != model3)
    }
}
