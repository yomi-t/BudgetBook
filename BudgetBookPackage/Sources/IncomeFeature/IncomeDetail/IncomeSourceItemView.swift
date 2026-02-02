import ComposableArchitecture
import Core
import SwiftUI

public struct IncomeSourceItemView: View {
    public var income: Income

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(income.source)
                    .font(.footnote)
                Spacer()
                    .layoutPriority(-.infinity)
                Text("\(income.amount)")
                    .font(.body)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 15)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
        }
        .padding(.horizontal, 16)
    }
}
