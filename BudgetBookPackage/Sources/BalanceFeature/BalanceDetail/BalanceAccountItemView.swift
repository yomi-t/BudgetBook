import ComposableArchitecture
import Core
import SwiftUI

public struct BalanceAccountItemView: View {
    public var balance: Balance

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(balance.account)
                    .font(.footnote)
                Spacer()
                    .layoutPriority(-.infinity)
                Text("\(balance.amount)")
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
