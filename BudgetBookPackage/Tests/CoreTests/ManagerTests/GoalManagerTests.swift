import Core
import Testing

private struct GoalManagerTests {
    struct RestToGoalTestCase {
        let goal: Int
        let income: Int
        let expected: Int
    }

    @Test(arguments: [
        RestToGoalTestCase(goal: 1000000, income: 300000, expected: 700000),
        RestToGoalTestCase(goal: 500000, income: 500000, expected: 0),
        RestToGoalTestCase(goal: 500000, income: 600000, expected: 0),
        RestToGoalTestCase(goal: 0, income: 0, expected: 0),
        RestToGoalTestCase(goal: 1000000, income: 0, expected: 1000000),
        RestToGoalTestCase(goal: 100000, income: 99999, expected: 1)
    ])
    func testRestToGoal(testCase: RestToGoalTestCase) {
        let result = GoalManager.restToGoal(goal: testCase.goal, income: testCase.income)
        #expect(result == testCase.expected)
    }

    struct MonthEstimateTestCase {
        let goal: Int
        let income: Int
        let leftMonthCount: Int
        let expected: Int
    }

    @Test(arguments: [
        MonthEstimateTestCase(goal: 1200000, income: 0, leftMonthCount: 12, expected: 100000),
        MonthEstimateTestCase(goal: 1200000, income: 600000, leftMonthCount: 6, expected: 100000),
        MonthEstimateTestCase(goal: 500000, income: 500000, leftMonthCount: 6, expected: 0),
        MonthEstimateTestCase(goal: 500000, income: 700000, leftMonthCount: 6, expected: 0),
        MonthEstimateTestCase(goal: 1000000, income: 0, leftMonthCount: 3, expected: 333333),
        MonthEstimateTestCase(goal: 1000000, income: 0, leftMonthCount: 1, expected: 1000000)
    ])
    func testMonthEstimate(testCase: MonthEstimateTestCase) {
        let result = GoalManager.monthEstimate(
            goal: testCase.goal,
            income: testCase.income,
            leftMonthCount: testCase.leftMonthCount
        )
        #expect(result == testCase.expected)
    }
}
