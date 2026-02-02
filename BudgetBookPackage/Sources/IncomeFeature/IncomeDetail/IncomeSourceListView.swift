import Core
import SwiftUI

public struct IncomeSourceListView: View {
    let datas: [Income]
    let year: Int
    let month: Int
    init(datas: [Income]) {
        self.datas = datas
        self.year = datas.first?.year ?? 0
        self.month = datas.first?.month ?? 0
    }
    public var body: some View {
        VStack(spacing: 0) {
            Text("\(String(year))年\(String(month))月の収入")
                .font(.title3)
                .padding(.bottom, 8)
                .padding(.top, 25)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            List {
                ForEach(datas, id: \.self) { data in
                    IncomeSourceItemView(income: data)
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            }
            .frame(maxHeight: .infinity)
            .listStyle(.plain)
        }
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .shadow(radius: 10)
    }
}
