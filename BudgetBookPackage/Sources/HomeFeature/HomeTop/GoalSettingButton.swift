import ComposableArchitecture
import Core
import SwiftUI

internal struct GoalSettingButton: View {
    let goal: Int
    let inputGoal: Binding<Int>
    let setGoal: () -> Void
    @State private var isPresentingAlert = false
    var body: some View {
        Button {
            isPresentingAlert = true
        } label: {
            VStack {
                Text(L10n.Goal.yearlyTarget)
                    .font(.callout)
                ZStack {
                    Text("\(goal)")
                        .font(.title)
                        .fontWeight(.bold)
                    HStack {
                        Spacer()
                        Text(L10n.Goal.setButton)
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
            L10n.Goal.Alert.title,
            isPresented: $isPresentingAlert,
            actions: {
                TextField(
                    L10n.Goal.Alert.placeholder,
                    value: inputGoal,
                    format: .number
                )
                Button(
                    L10n.Common.cancel,
                    role: .cancel
                ) {

                }
                Button(L10n.Common.set) {
                    setGoal()
                }
            }, message: {
                Text(L10n.Goal.Alert.message)
            }
        )
    }
}
