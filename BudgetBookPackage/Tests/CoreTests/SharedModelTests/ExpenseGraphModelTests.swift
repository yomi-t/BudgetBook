import Core
import Testing

private struct ExpenseGraphModelTests {
    @Test(arguments: [
        ExpenseGraphModel(id: "test-id", yearMonth: "25/03", amount: 50000)
    ])
    func testInitWithId(_ model: ExpenseGraphModel) {
        #expect(model.id == "test-id")
        #expect(model.yearMonth == "25/03")
        #expect(model.amount == 50000)
    }

    @Test
    func testInitWithoutIdGeneratesId() {
        let model1 = ExpenseGraphModel(yearMonth: "25/03", amount: 50000)
        let model2 = ExpenseGraphModel(yearMonth: "25/03", amount: 50000)

        #expect(!model1.id.isEmpty)
        #expect(!model2.id.isEmpty)
        #expect(model1.id != model2.id)
    }

    struct SortByMonthTestCase {
        let input: [String]
        let expected: [String]
    }

    @Test(arguments: [
        SortByMonthTestCase(
            input: ["25/05", "25/03", "24/12", "26/01"],
            expected: ["24/12", "25/03", "25/05", "26/01"]
        ),
        SortByMonthTestCase(
            input: ["25/05", "25/01", "25/03"],
            expected: ["25/01", "25/03", "25/05"]
        ),
        SortByMonthTestCase(
            input: ["25/12", "25/01", "24/06", "26/03"],
            expected: ["24/06", "25/01", "25/12", "26/03"]
        )
    ])
    func testSortByMonth(testCase: SortByMonthTestCase) {
        let models = testCase.input.enumerated().map { index, yearMonth in
            ExpenseGraphModel(id: "\(index)", yearMonth: yearMonth, amount: 10000)
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
            ExpenseGraphModel(id: "\(index)", yearMonth: "25/03", amount: amount)
        }

        let range = models.rangeAmount()

        #expect(range.lowerBound == testCase.expectedLower)
        #expect(range.upperBound == testCase.expectedUpper)
    }

    @Test
    func testEquatable() {
        let model1 = ExpenseGraphModel(id: "same-id", yearMonth: "25/03", amount: 50000)
        let model2 = ExpenseGraphModel(id: "same-id", yearMonth: "25/03", amount: 50000)
        let model3 = ExpenseGraphModel(id: "different-id", yearMonth: "25/03", amount: 50000)

        #expect(model1 == model2)
        #expect(model1 != model3)
    }
}
