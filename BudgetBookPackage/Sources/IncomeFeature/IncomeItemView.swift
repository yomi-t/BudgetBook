import ComposableArchitecture
import Core
import SwiftUI

public struct IncomeItemView: View {
    public var income: Income

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(income.year - 2000)年\(income.month)月")
                Text(income.source)
                    .font(.title3)
                Spacer()
                    .layoutPriority(-.infinity)
                Text("\(income.amount)")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 20)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    IncomeItemView(income: .init(
        source: "リクルート",
        year: 2024,
        month: 6,
        amount: 300_000
    ))
}
