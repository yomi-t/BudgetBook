import ComposableArchitecture
import Core
import SwiftUI

public struct AccountSettingView: View {
    
    @Binding var accounts: [Account]
    private var deleteAccountAction: (Account) -> Void
    private var showAddAccountView: (Bool) -> Void
    
    public init(accounts: Binding<[Account]>, deleteAccountAction: @escaping (Account) -> Void, showAddAccountView: @escaping (Bool) -> Void) {
        self._accounts = accounts
        self.deleteAccountAction = deleteAccountAction
        self.showAddAccountView = showAddAccountView
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Text("口座の編集")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 10) {
                    ForEach(accounts, id: \.self) { account in
                        HStack {
                            Text(account.name)
                            
                            Spacer()
                            
                            // swiftlint:disable:next multiline_arguments
                            Button(action: {
                                deleteAccountAction(account)
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
                        showAddAccountView(true)
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
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .shadow(radius: 10)
        }
    }
}
