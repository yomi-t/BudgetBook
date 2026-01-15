import ComposableArchitecture
import SwiftUI

public struct IncomeYearView: View {
    public let store: StoreOf<IncomeYearReducer>
    public init (store: StoreOf<IncomeYearReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("今年一年の収入")
                .font(.callout)
                .fontWeight(.light)
                .padding(.bottom, 5)
            HStack {
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundStyle(.clear)
                Text("\(store.incomeYearTotal)")
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
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .shadow(radius: 10)
    }
}
