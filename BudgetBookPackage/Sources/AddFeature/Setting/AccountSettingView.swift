import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: AccountSettingReducer.self)
public struct AccountSettingView: View {
    
    @Bindable public var store: StoreOf<AccountSettingReducer>
    public init(store: StoreOf<AccountSettingReducer>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text(L10n.AccountSetting.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 10) {
                        ForEach(store.accounts, id: \.self) { account in
                            HStack {
                                Text(account.name)
                                
                                Spacer()
                                
                                Button {
                                    send(.onTapDeleteAccount(account))
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .background(.thickMaterial)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                        }
                        
                        Button {
                            send(.showAddAlert(true))
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding(15)
                                .frame(maxWidth: .infinity)
                                .background(.thickMaterial)
                                .cornerRadius(15)
                                .shadow(radius: 10)
                        }
                    }
                }
                .padding(20)
                .background(.thickMaterial)
                .cornerRadius(20)
                .padding(.top, 10)
                .padding(.horizontal, 20)
                .shadow(radius: 10)
            }
        }
        .onAppear {
            send(.onAppear)
        }
        .alert(L10n.AccountSetting.Alert.title, isPresented: $store.isShowAddAlert) {
            TextField(L10n.AccountSetting.Alert.placeholder, text: $store.addAccountName)
            Button(L10n.Common.cancel) {
                send(.showAddAlert(false))
            }
            Button(L10n.Common.confirm) {
                send(.onTapAddAccount)
                send(.showAddAlert(false))
            }
            .disabled(store.addAccountName.isEmpty)
        }
    }
}
