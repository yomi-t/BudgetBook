import Core
import SwiftUI

public struct ExpenseItemView: View {
    public var expense: MonthlyExpense

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(L10n.Common.yearMonth(expense.year % 1000, expense.month))
                    .font(.footnote)
                Spacer()
                    .layoutPriority(-.infinity)
                Text("\(expense.amount)")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.red)
                Text(L10n.Common.currency)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 8)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 15)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
        }
    }
}
