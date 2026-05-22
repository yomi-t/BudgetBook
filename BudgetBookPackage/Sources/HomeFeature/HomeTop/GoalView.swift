import Core
import SwiftUI

internal struct GoalView: View {
    let toGoal: Int
    let monthEstimate: Int
    var body: some View {
        VStack {
            Text(L10n.Goal.toGoal)
                .font(.callout)
                .fontWeight(.medium)
                .padding(.bottom, 2)
            HStack {
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundStyle(.clear)
                Text("\(toGoal)")
                    .font(.title)
                    .fontWeight(.bold)
                Text(L10n.Common.currency)
                    .font(.footnote)
                    .fontWeight(.light)
                    .frame(width: 20)
            }
            .padding(.bottom, 10)
            Text(L10n.Goal.monthEstimate)
                .font(.callout)
                .fontWeight(.medium)
                .padding(.bottom, 2)
            HStack {
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundStyle(.clear)
                Text("\(monthEstimate)")
                    .font(.title)
                    .fontWeight(.bold)
                Text(L10n.Common.currency)
                    .font(.footnote)
                    .fontWeight(.light)
                    .frame(width: 20)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(.thickMaterial)
        .cornerRadius(20)
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .shadow(radius: 10)
    }
}
