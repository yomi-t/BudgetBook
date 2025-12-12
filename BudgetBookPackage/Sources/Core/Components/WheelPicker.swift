import SwiftUI

public struct WheelPicker: View {
    @Binding var selectedValue: String
    @Binding var values: [String]
    @State var isOpen: Bool = false
    @State var width: CGFloat
    
    public init(selectedValue: Binding<String>, values: Binding<[String]>, width: CGFloat = 50) {
        _selectedValue = selectedValue
        _values = values
        self.width = width
    }
    
    public var body: some View {
        ZStack {
            Button {
                isOpen.toggle()
            } label: {
                Text("\(selectedValue)")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(minWidth: width)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .sheet(isPresented: $isOpen) {
                VStack(spacing: 16) {
                    HStack {
                        Spacer()
                        Button {
                            isOpen = false
                        } label: {
                            Text("完了")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Picker(selection: $selectedValue, label: Text("Select Value")) {
                        ForEach(values, id: \.self) { value in
                            Text("\(value)")
                                .font(.title2)
                                .tag(value)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 180)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
            }
        }
    }
}
