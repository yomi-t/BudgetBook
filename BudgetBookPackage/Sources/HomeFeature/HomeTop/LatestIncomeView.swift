import SwiftUI

internal struct LatestIncomeView: View {
    let latestIncome: Int
    var body: some View {
        VStack {
            Text("先月の収入")
                .font(.callout)
                .foregroundStyle(Color.green)
                .fontWeight(.medium)
                .padding(.bottom, 5)
            HStack {
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundStyle(.clear)
                Text("\(latestIncome)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("円")
                    .font(.footnote)
                    .fontWeight(.light)
                    .frame(width: 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(.thickMaterial)
        .cornerRadius(20)
        .padding(.top, 20)
        .padding(.leading, 20)
        .padding(.trailing, 10)
        .shadow(radius: 10)
    }
}
