public struct GoalManager: Sendable {
        
    public static func restToGoal(goal: Int, income: Int) -> Int {
        let rest = goal - income
        return max(0, rest)
    }
    
    public static func monthEstimate(goal: Int, income: Int, leftMonthCount: Int) -> Int {
        let rest = restToGoal(goal: goal, income: income)
        return max(0, rest / leftMonthCount)
    }
}
