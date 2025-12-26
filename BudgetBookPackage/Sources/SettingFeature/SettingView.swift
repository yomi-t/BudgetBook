import ComposableArchitecture
import SwiftUI

public struct SettingView: View {
    @Bindable public var store: StoreOf<SettingReducer>
    public init (store: StoreOf<SettingReducer>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("設定画面")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                }
                .background(.thickMaterial)
                .cornerRadius(20)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .shadow(radius: 10)
                
                AccountSettingView(
                    accounts: $store.accounts,
                    deleteAccountAction: {
                        store.send(.onTapDeleteAccount($0))
                    }, showAddAccountView: {
                        store.send(.showAddAccountAlert($0))
                    }
                )

                SourceSettingView(
                    sources: $store.sources,
                    deleteSourceAction: {
                        store.send(.onTapDeleteSource($0))
                    }, showAddSourceView: {
                        store.send(.showAddSourceAlert($0))
                    }
                )

                Spacer()
            }
            if store.isShowAddAccountAlert {
                AddAccountView(
                    title: "口座を追加",
                    isPresented: $store.isShowAddAccountAlert
                ) {
                    store.send(.onTapAddAccount($0))
                }
            }
            if store.isShowAddSourceAlert {
                AddSourceView(
                    title: "収入源を追加",
                    isPresented: $store.isShowAddSourceAlert
                ) {
                    store.send(.onTapAddSource($0))
                }
            }
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

#Preview {
    SettingView(store: .init(
        initialState: SettingReducer.State()
    ) {
        SettingReducer()
    })
}
