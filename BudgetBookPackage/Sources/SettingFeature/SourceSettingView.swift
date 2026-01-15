import ComposableArchitecture
import Core
import SwiftUI

public struct SourceSettingView: View {
    
    @Bindable private var store: StoreOf<SourceSettingReducer>
    public init (
        store: StoreOf<SourceSettingReducer>
    ) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Text("収入源の編集")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 10) {
                    ForEach(store.sources, id: \.self) { source in
                        HStack {
                            Text(source.name)
                            
                            Spacer()
                            
                            // swiftlint:disable:next multiline_arguments
                            Button(action: {
                                store.send(.onTapDeleteSource(source))
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
                        store.send(.showAddAlert(true))
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
        .onAppear {
            store.send(.view(.onAppear))
        }
        .alert("収入源を追加", isPresented: $store.isShowAddAlert) {
            TextField("収入源を入力", text: $store.addSourceName)
            Button("キャンセル", role: .cancel) {
                store.send(.showAddAlert(false))
            }
            Button("決定") {
                store.send(.onTapAddSource) // 親に値を渡す
                store.send(.showAddAlert(false))
            }
            .disabled(store.addSourceName.isEmpty)
        }
    }
}
