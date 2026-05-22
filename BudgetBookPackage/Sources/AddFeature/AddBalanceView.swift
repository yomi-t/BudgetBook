import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: AddBalanceReducer.self)
public struct AddBalanceView: View {
    @FocusState private var focusState: Bool
    @Bindable public var store: StoreOf<AddBalanceReducer>
    let numberFormatter: NumberFormatter
    public init(store: StoreOf<AddBalanceReducer>) {
        self.store = store
        numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
    }
    
    public var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    self.focusState = false
                }
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header
                    Text(L10n.Add.Balance.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Date Selection Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L10n.Add.Balance.dateSection)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 12) {
                            Spacer()
                            WheelPicker(
                                selectedValue: Binding(
                                    get: { String(store.selectedYear) },
                                    set: { store.selectedYear = Int($0) ?? store.selectedYear }
                                ),
                                values: $store.years,
                                width: 80
                            )
                            Text(L10n.Common.year)
                                .foregroundColor(.secondary)
                            
                            WheelPicker(
                                selectedValue: Binding(
                                    get: { String(store.selectedMonth) },
                                    set: { store.selectedMonth = Int($0) ?? store.selectedMonth }
                                ),
                                values: $store.months
                            )
                            Text(L10n.Add.Balance.endOfMonth)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    
                    // Account Selection Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(L10n.Add.Balance.accountSection)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Button {
                                send(.tapSettingBtn)
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if store.accounts.isEmpty {
                            Button {
                                send(.tapSettingBtn)
                            } label: {
                                HStack {
                                    Text(L10n.Add.Balance.addAccountPrompt)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        } else {
                            Menu {
                                Picker(L10n.Add.Balance.accountSection, selection: $store.selectedAccount) {
                                    ForEach(store.accounts, id: \.self) { account in
                                        Text(account.name)
                                            .tag(account.name)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(store.selectedAccount)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }
                    // Amount Input Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L10n.Add.Balance.amountSection)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField(L10n.Common.amountPlaceholder, value: $store.amount, formatter: numberFormatter)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            #endif
                            .focused(self.$focusState)
                            .multilineTextAlignment(.trailing)
                            .font(.title3)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Add Button
                    Button {
                        send(.tapAddBtn)
                    } label: {
                        Text(L10n.Common.add)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .padding(.top, 8)
                }
                .padding(.vertical, 24)
            }
            .padding(.horizontal, 20)
        }
        .onTapGesture {
            self.focusState = false
        }
        .background(.thickMaterial)
        .cornerRadius(20)
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .shadow(radius: 10)
        .onAppear {
            send(.onAppear)
        }
        .sheet(isPresented: $store.isSettingSheetPresented) {
            AccountSettingView(store: store.scope(state: \.accountSettingState, action: \.accountSetting))
        }
    }
}
