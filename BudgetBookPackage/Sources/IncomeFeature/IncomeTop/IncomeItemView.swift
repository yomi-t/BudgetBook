import ComposableArchitecture
import Core
import SwiftUI

public struct IncomeItemView: View {
    public var monthlyIncome: [Income]

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\((monthlyIncome.first?.year ?? 0) % 1000)年\(monthlyIncome.first?.month ?? 0)月")
                    .font(.footnote)
                Spacer()
                    .layoutPriority(-.infinity)
                Text("\(monthlyIncome.reduce(0) { $0 + $1.amount })")
                    .font(.body)
                    .fontWeight(.medium)
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 5, height: 10)
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal, 3)
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
