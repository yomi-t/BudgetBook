import ComposableArchitecture
import SwiftUI

public struct LatestBalanceView: View {
    let latestMoney: Int

    public var body: some View {
        VStack {
            Text("先月の残金")
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
                Text("円")
                    .font(.footnote)
                    .fontWeight(.light)
                    .frame(width: 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 120)
        .background(.thickMaterial)
        .cornerRadius(20)
//        .padding(.top, 20)
        .padding(.horizontal, 20)
        .shadow(radius: 10)
    }
}
