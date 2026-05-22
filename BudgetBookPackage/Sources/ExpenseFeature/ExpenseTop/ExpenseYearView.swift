import ComposableArchitecture
import Core
import SwiftUI

public struct ExpenseYearView: View {
    public let store: StoreOf<ExpenseYearReducer>

    public init(store: StoreOf<ExpenseYearReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text(L10n.Expense.Year.title)
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
        .padding(.horizontal, 20)
        .shadow(radius: 10)
    }
}
