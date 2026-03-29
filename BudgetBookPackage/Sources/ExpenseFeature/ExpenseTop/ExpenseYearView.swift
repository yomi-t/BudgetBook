import ComposableArchitecture
import SwiftUI

public struct ExpenseYearView: View {
    public let store: StoreOf<ExpenseYearReducer>

    public init(store: StoreOf<ExpenseYearReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("今年一年の支出")
                .font(.callout)
                .fontWeight(.light)
                .padding(.bottom, 5)
            HStack {
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundStyle(.clear)
                Text("\(store.expenseYearTotal)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
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
