import ComposableArchitecture
import SwiftUI

public struct LastMoneyView: View {
    public let store: StoreOf<LatestMoneyReducer>
    public init (store: StoreOf<LatestMoneyReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("先月の残金")
                .font(.callout)
                .fontWeight(.light)
                .padding(.bottom, 5)
            HStack {
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundStyle(.clear)
                Text("\(store.latestMoney)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("円")
                    .font(.footnote)
                    .fontWeight(.light)
                    .frame(width: 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(.thickMaterial)
        .cornerRadius(20)
        .padding(.top, 30)
        .padding(.horizontal, 20)
        .shadow(radius: 10)
    }
}

#Preview {
    LastMoneyView(store: .init(
        initialState: LatestMoneyReducer.State(latestMoney: 392_012)
    ) {
        LatestMoneyReducer()
    })
}
