import ComposableArchitecture
import Core
import SwiftUI

internal struct LatestBalanceView: View {
    let latestMoney: Int

    var body: some View {
        VStack {
            Text(L10n.Latest.balance)
                .font(.callout)
                .fontWeight(.medium)
                .padding(.bottom, 5)
            HStack {
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundStyle(.clear)
                Text("\(latestMoney)")
                    .font(.title)
                    .fontWeight(.bold)
                Text(L10n.Common.currency)
                    .font(.footnote)
                    .fontWeight(.light)
                    .frame(width: 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 120)
        .background(.thickMaterial)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(radius: 10)
    }
}
