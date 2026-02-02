import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: IncomeSourceListReducer.self)
public struct IncomeSourceListView: View {
    public let store: StoreOf<IncomeSourceListReducer>
    public init (store: StoreOf<IncomeSourceListReducer>) {
        self.store = store
    }
    public var body: some View {
        VStack(spacing: 0) {
            Text("\(String(store.year))年\(String(store.month))月の収入")
                .font(.title3)
                .padding(.bottom, 8)
                .padding(.top, 25)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            List {
                ForEach(store.incomes, id: \.self) { data in
                    IncomeSourceItemView(income: data)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                send(.onTapDelete(data))
                            } label: {
                                Label("", systemImage: "trash")
                            }
                        }
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            }
            .frame(maxHeight: .infinity)
            .listStyle(.plain)
        }
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .shadow(radius: 10)
    }
}
