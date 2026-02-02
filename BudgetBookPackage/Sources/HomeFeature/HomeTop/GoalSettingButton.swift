import ComposableArchitecture
import SwiftUI

public struct GoalSettingButton: View {
    let goal: Int
    let inputGoal: Binding<Int>
    let setGoal: () -> Void
    @State private var isPresentingAlert = false
    public var body: some View {
        Button {
            isPresentingAlert = true
        } label: {
            VStack {
                Text("1年間の収入目標金額")
                    .font(.callout)
                ZStack {
                    Text("\(goal)")
                        .font(.title)
                        .fontWeight(.bold)
                    HStack {
                        Spacer()
                        Text("設定する")
                            .font(.caption)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 5, height: 10)
                    }
                }
            }
            .padding(.vertical, 20)
            .foregroundStyle(.black)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(.thickMaterial)
            .cornerRadius(20)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .shadow(radius: 10)
        }
        .alert(
            "目標金額の設定",
            isPresented: $isPresentingAlert,
            actions: {
                TextField(
                    "目標金額を入力してください",
                    value: inputGoal,
                    format: .number
                )
                Button(
                    "キャンセル",
                    role: .cancel
                ) {

                }
                Button("設定") {
                    setGoal()
                }
            }, message: {
                Text("1年間の収入目標金額を設定します。")
            }
        )
    }
}
