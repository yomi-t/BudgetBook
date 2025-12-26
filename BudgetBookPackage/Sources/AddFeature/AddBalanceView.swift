import ComposableArchitecture
import Core
import SwiftUI

public struct AddBalanceView: View {
    @FocusState private var focusState: Bool
    @Bindable private var store: StoreOf<AddBalanceReducer>
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
                    Text("残高を追加")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Date Selection Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("決算月")
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
                            Text("年")
                                .foregroundColor(.secondary)
                            
                            WheelPicker(
                                selectedValue: Binding(
                                    get: { String(store.selectedMonth) },
                                    set: { store.selectedMonth = Int($0) ?? store.selectedMonth }
                                ),
                                values: $store.months
                            )
                            Text("月末")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    .cornerRadius(12)
                    
                    // Account Selection Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("口座")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Menu {
                            Picker("口座", selection: $store.selectedAccount) {
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
                    .cornerRadius(12)
                    
                    // Amount Input Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("残高")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("金額を入力", value: $store.amount, formatter: numberFormatter)
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
                    .cornerRadius(12)
                    
                    // Add Button
                    Button {
                        store.send(.tapAddBtn)
                    } label: {
                        Text("追加")
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
            store.send(.view(.onAppear))
        }
    }
}
