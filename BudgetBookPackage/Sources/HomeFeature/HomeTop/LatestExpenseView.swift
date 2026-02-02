import SwiftUI

struct LatestExpenseView: View {
    let latestExpense: Int
    var body: some View {
        VStack {
            Text("先月の支出")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(Color.red)
                .padding(.bottom, 5)
            HStack {
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundStyle(.clear)
                Text("\(latestExpense)")
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
        .padding(.trailing, 20)
        .shadow(radius: 10)
    }
}
