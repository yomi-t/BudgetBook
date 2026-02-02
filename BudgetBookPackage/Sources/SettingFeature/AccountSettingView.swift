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
            VStack {
                Text("口座の編集")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 10) {
                    ForEach(store.accounts, id: \.self) { account in
                        HStack {
                            Text(account.name)
                            
                            Spacer()
                            
                            // swiftlint:disable:next multiline_arguments
                            Button(action: {
                                send(.onTapDeleteAccount(account))
                            }, label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            })
                        }
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(.thickMaterial)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                    
                    // swiftlint:disable:next multiline_arguments
                    Button(action: {
                        send(.showAddAlert(true))
                    }, label: {
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
                    })
                }
            }
            .padding(20)
            .background(.thickMaterial)
            .cornerRadius(20)
            .padding(.top, 10)
            .padding(.horizontal, 20)
            .shadow(radius: 10)
        }
        .onAppear {
            send(.onAppear)
        }
        .alert("口座を追加", isPresented: $store.isShowAddAlert) {
            TextField("口座名を入力", text: $store.addAccountName)
            Button("キャンセル") {
                send(.showAddAlert(false))
            }
            Button("決定") {
                send(.onTapAddAccount)
                send(.showAddAlert(false))
            }
            .disabled(store.addAccountName.isEmpty)
        }
    }
}
