import ComposableArchitecture
import Core
import SwiftUI

public struct SourceSettingView: View {
    
    @Binding var sources: [Source]
    private var deleteSourceAction: (Source) -> Void
    private var showAddSourceView: (Bool) -> Void
    
    public init(sources: Binding<[Source]>, deleteSourceAction: @escaping (Source) -> Void, showAddSourceView: @escaping (Bool) -> Void) {
        self._sources = sources
        self.deleteSourceAction = deleteSourceAction
        self.showAddSourceView = showAddSourceView
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Text("収入源の編集")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 10) {
                    ForEach(sources, id: \.self) { source in
                        HStack {
                            Text(source.name)
                            
                            Spacer()
                            
                            // swiftlint:disable:next multiline_arguments
                            Button(action: {
                                deleteSourceAction(source)
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
                        showAddSourceView(true)
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
