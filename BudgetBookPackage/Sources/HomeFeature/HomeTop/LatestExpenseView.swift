import Core
import SwiftUI

internal struct LatestExpenseView: View {
    let latestExpense: Int
    var body: some View {
        VStack {
            Text(L10n.Latest.expense)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(Color.red)
                .padding(.bottom, 5)
            HStack {
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundStyle(.clear)
                Text("\(latestExpense)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text(L10n.Common.currency)
                    .font(.footnote)
                    .fontWeight(.light)
                    .frame(width: 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(.thickMaterial)
        .cornerRadius(20)
        .padding(.top, 20)
        .padding(.trailing, 20)
        .shadow(radius: 10)
    }
}
