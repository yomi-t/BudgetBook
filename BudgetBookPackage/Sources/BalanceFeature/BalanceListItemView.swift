import ComposableArchitecture
import Core
import SwiftUI

public struct BalanceListItemView: View {
    
    var balance: Balance

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(balance.year - 2000)年\(balance.month)月")
                    .font(.footnote)
                Text(balance.account)
                    .font(.body)
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
