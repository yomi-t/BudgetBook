import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: SourceSettingReducer.self)
public struct SourceSettingView: View {
    
    @Bindable public var store: StoreOf<SourceSettingReducer>
    public init (
        store: StoreOf<SourceSettingReducer>
    ) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text(L10n.SourceSetting.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 10) {
                        ForEach(store.sources, id: \.self) { source in
                            HStack {
                                Text(source.name)
                                
                                Spacer()
                                
                                Button {
                                    send(.onTapDeleteSource(source))
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
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .shadow(radius: 10)
            }
        }
        .onAppear {
            send(.onAppear)
        }
        .alert(L10n.SourceSetting.Alert.title, isPresented: $store.isShowAddAlert) {
            TextField(L10n.SourceSetting.Alert.placeholder, text: $store.addSourceName)
            Button(L10n.Common.cancel, role: .cancel) {
                send(.showAddAlert(false))
            }
            Button(L10n.Common.confirm) {
                send(.onTapAddSource)
                send(.showAddAlert(false))
            }
            .disabled(store.addSourceName.isEmpty)
        }
    }
}
